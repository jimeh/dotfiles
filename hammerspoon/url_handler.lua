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

--- url_handler.browsers
--- Variable
--- A table of browser names and corresponding bundle IDs that can be used in
--- the url_patterns table.
obj.browsers = {
  arc       = 'com.arc.arc',
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
  tor       = 'org.mozilla.tor browser',
  vivaldi   = 'com.vivaldi.Vivaldi',
  waterfox  = 'net.waterfox.waterfox',
  yandex    = 'ru.yandex.desktop.yandex-browser',
}

--- url_handler.open(appID, url)
--- Function
--- Open url with the specified application bundle ID. This is a helper function
--- that's useful if you need to build custom functions to open URLs.
function obj.open(url, appID)
  hs.application.launchOrFocusByBundleID(appID)
  hs.urlevent.openURLWithBundle(url, appID)
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

--- url_handler.init()
--- Function
--- Initialize URL handler. This will set the default_handler, url_patterns,
--- and url_redir_decoders on the URLDispatcher spoon, followed by calling its
--- start() method.
function obj:init()
  local keys = {
    "default_handler",
    "decode_slack_redir_urls",
    "url_patterns",
    "url_redir_decoders"
  }

  for _, key in ipairs(keys) do
    if self[key] ~= nil then
      self._url_dispatcher[key] = self[key]
    end
  end

  self._url_dispatcher:start()
end

-- the end
return obj
