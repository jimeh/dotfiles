-- luacheck: read_globals hs

hs.loadSpoon('URLDispatcher')

local ud = spoon.URLDispatcher
local obj = {}

--
-- Helpers
--
-- Borrowed from:
-- https://github.com/zzamboni/dot-hammerspoon/blob/master/init.org

local function appID(app)
  if hs.application.infoForBundlePath(app) then
    return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
  end
end

local function chromeProfile(profile)
  return function(url)
    hs.task.new("/usr/bin/open", nil, {
      "-n",
      "-a", "Google Chrome",
      "--args",
      "--profile-directory=" .. profile,
      url
    }):start()
  end
end

--
-- Configuration
--

function obj:init()
  local browsers        = {
    arc     = appID('/Applications/Arc.app'),
    chrome  = appID('/Applications/Google Chrome.app'),
    edge    = appID('/Applications/Microsoft Edge.app'),
    firefox = appID('/Applications/Firefox.app'),
    orion   = appID('/Applications/Orion.app'),
    safari  = appID('/Applications/Safari.app')
  }
  local chromeProfiles  = {
    default = chromeProfile("Default"),
    work    = chromeProfile("Profile 1"),
  }

  ud.default_handler    = browsers.safari
  ud.url_patterns       = {
    {
      { "%://github.com/", "%://%.github.com/" },
      browsers.edge, nil, { "Slack" }
    },
    {
      { "%://meet.google.com/" },
      chromeProfiles.work, nil, { "Slack", "Calendar" }
    }
  }
  ud.url_redir_decoders = {
    -- {
    --   "MS Teams links",
    --   function(_, _, params, fullUrl)
    --     if params.url then
    --       return params.url
    --     else
    --       return fullUrl
    --     end
    --   end,
    --   nil, true, "Microsoft Teams"
    -- },
  }

  ud:start()
end

-- the end
return obj
