-- luacheck: read_globals hs

--- === url_handler ===
---
--- URL handler for Hammerspoon. This module wraps the URLDispatcher spoon with
--- a number of extra helper function to make it easier to configure.
---
--- You will need to separately install the URLDispatcher spoon for this module
--- to work.

hs.loadSpoon('URLDispatcher')
local obj = {
  _url_dispatcher = spoon.URLDispatcher
}

local browser_bundle_ids = {
  arc       = 'company.thebrowser.Browser',
  brave     = 'com.brave.Browser',
  camino    = 'org.mozilla.camino',
  chrome    = 'com.google.Chrome',
  chromium  = 'org.chromium.Chromium',
  edge      = 'com.microsoft.edgemac',
  firefox   = 'org.mozilla.firefox',
  flock     = 'com.flock.Flock',
  icab      = 'de.icab.iCab',
  maxthon   = 'com.maxthon.Maxthon',
  omniweb   = 'com.omnigroup.OmniWeb5',
  opera     = 'com.operasoftware.Opera',
  orion     = 'com.orionbrowser.orion',
  palemoon  = 'com.palemoon.palemoon',
  safari    = 'com.apple.Safari',
  seamonkey = 'org.mozilla.seamonkey',
  sigmaos   = 'com.sigmaos.sigmaos.macos',
  tor       = 'org.mozilla.tor browser',
  vivaldi   = 'com.vivaldi.Vivaldi',
  waterfox  = 'net.waterfox.waterfox',
  yandex    = 'ru.yandex.desktop.yandex-browser',
  zen       = 'app.zen-browser.zen',
}

--- url_handler.default_handler
--- Variable
--- The default handler for URLs that don't match any of the patterns. If this
--- is not nil, it will be set as default_handler on the URLDispatcher spoon.
obj.default_handler = nil

--- url_handler.decode_slack_redir_urls
--- Variable
--- A boolean indicating whether to decode Slack redirect URLs. If this is not
--- nil, it will be set as decode_slack_redir_urls on the URLDispatcher spoon.
obj.decode_slack_redir_urls = nil

--- url_handler.url_patterns
--- Variable
--- A table of URL patterns to match against. If this is not nil, it will be set
--- as url_patterns on the URLDispatcher spoon.
obj.url_patterns = nil

--- url_handler.url_redir_decoders
--- Variable
--- A table of URL redirect decoders. If this is not nil, it will be set as
--- url_redir_decoders on the URLDispatcher spoon.
obj.url_redir_decoders = nil

--- url_handler.focus_before_dispatch
--- Variable
--- If true, focus matching apps before dispatching URLs. Defaults to `false`
---
--- Notes:
--- Set to `true` to always focus a matching browser before opening the URL.
obj.focus_before_dispatch = false

--- url_handler.browsers
--- Variable
--- A table of browser names and corresponding URL handler functions that can
--- be used in the url_patterns table.
obj.browsers = {}

--- url_handler.open(url, appID)
--- Function
--- Open url with the specified application bundle ID. This is a helper function
--- that's useful if you need to build custom functions to open URLs.
function obj.open(url, appID)
  obj._prepareBundleIDForDispatch(appID)
  hs.urlevent.openURLWithBundle(url, appID)
end

function obj._launchBundleIDIfNotRunning(bundleID)
  local apps = hs.application.applicationsForBundleID(bundleID) or {}
  if #apps > 0 then
    return false
  end

  hs.application.launchOrFocusByBundleID(bundleID)
  return true
end

function obj._prepareBundleIDForDispatch(bundleID)
  if obj.focus_before_dispatch then
    hs.application.launchOrFocusByBundleID(bundleID)
    return true
  end

  return obj._launchBundleIDIfNotRunning(bundleID)
end

--- url_handler.bundleHandler(bundleID)
--- Function
--- Returns a function that prepares the specified app and opens the given URL
--- using its bundle ID.
function obj.bundleHandler(bundleID)
  return function(url)
    obj.open(url, bundleID)
  end
end

--- url_handler.appID(appPath)
--- Function
--- Returns the bundle ID for the specified application path.
function obj.appID(appPath)
  local info = hs.application.infoForBundlePath(appPath)
  if info then
    return info['CFBundleIdentifier']
  end
end

function obj._chromiumProfile(app, profile)
  return function(url)
    hs.task.new("/usr/bin/open", nil, {
      "-n",
      "-a", app,
      "--args",
      "--profile-directory=" .. profile,
      url
    }):start()
  end
end

--- url_handler.chromeProfile(profile)
--- Function
--- Returns a function that opens the specified URL in Google Chrome using the
--- given profile.
---
--- This assumes that Microsoft Edge is already installed and available to use.
function obj.chromeProfile(profile)
  return obj._chromiumProfile("Google Chrome", profile)
end

--- url_handler.edgeProfile(profile)
--- Function
--- Returns a function that opens the specified URL in Microsoft Edge using the
--- given profile.
---
--- This assumes that Microsoft Edge is already installed and available to use.
function obj.edgeProfile(profile)
  return obj._chromiumProfile("Microsoft Edge", profile)
end

function obj._normalizeHandler(handler)
  if type(handler) == "string" then
    return obj.bundleHandler(handler)
  end

  return handler
end

function obj._normalizeURLPatterns(url_patterns)
  local normalized_patterns = {}

  for _, pattern in ipairs(url_patterns) do
    local normalized_pattern = {}

    for index = 1, 4 do
      normalized_pattern[index] = pattern[index]
    end

    normalized_pattern[2] = obj._normalizeHandler(normalized_pattern[2])
    table.insert(normalized_patterns, normalized_pattern)
  end

  return normalized_patterns
end

--- url_handler.init()
--- Function
--- Initialize URL handler. This will set the default_handler, url_patterns,
--- and url_redir_decoders on the URLDispatcher spoon, followed by calling its
--- start() method.
function obj:init()
  if self.default_handler ~= nil then
    self._url_dispatcher.default_handler =
        self._normalizeHandler(self.default_handler)
  end

  if self.decode_slack_redir_urls ~= nil then
    self._url_dispatcher.decode_slack_redir_urls =
        self.decode_slack_redir_urls
  end

  if self.url_patterns ~= nil then
    self._url_dispatcher.url_patterns =
        self._normalizeURLPatterns(self.url_patterns)
  end

  if self.url_redir_decoders ~= nil then
    self._url_dispatcher.url_redir_decoders = self.url_redir_decoders
  end

  self._url_dispatcher:start()
end

for name, bundle_id in pairs(browser_bundle_ids) do
  obj.browsers[name] = obj.bundleHandler(bundle_id)
end

-- the end
return obj
