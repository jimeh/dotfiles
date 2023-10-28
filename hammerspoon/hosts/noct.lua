local obj = {}

--------------------------------------------------------------------------------
-- Global Hotkeys
--------------------------------------------------------------------------------

local apptoggle = require('app_toggle')

local function init_hotkeys()
  apptoggle:bind({ 'cmd', 'alt', 'ctrl' }, 'A', { 'Activity Monitor' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '2', { 'ChatGPT' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '4', { 'FastGPT' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '5', { 'Microsoft Edge' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'A', { 'Messages' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'B', { 'TablePlus' }, { 'Lens' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'C', { 'Calendar' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'D', { 'Mimestream' }, { 'Mailplane' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'E', { 'Emacs', '/Applications/Emacs.app' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'F', { 'Element Nightly' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'S', { 'Music' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'T', { 'Discord PTB' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'X', { 'Notion' }, { 'Obsidian' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'Z', { 'Slack' })

  apptoggle:bind({ 'cmd', 'ctrl' }, 'W',
    { 'Code - Insiders', '/Applications/Visual Studio Code - Insiders.app' },
    { 'Code', '/Applications/Visual Studio Code.app' }
  )
end

--------------------------------------------------------------------------------
-- URL Handling
--------------------------------------------------------------------------------

local uh = require('url_handler')

local function init_url_handler()
  local chromeProfiles = {
    default = uh.chromeProfile("Default"),
    work    = uh.chromeProfile("Profile 1"),
  }

  uh.default_handler   = uh.browsers.safari
  uh.url_patterns      = {
    {
      { "%://github.com/krystal/", "%://%.github.com/krystal/" },
      uh.browsers.edge, nil, { "Slack" }
    },
    {
      { "%://meet.google.com/" },
      chromeProfiles.work, nil, { "Slack", "Calendar" }
    }
  }
  -- uh.url_redir_decoders = {
  --   {
  --     "MS Teams links",
  --     function(_, _, params, fullUrl)
  --       if params.url then
  --         return params.url
  --       else
  --         return fullUrl
  --       end
  --     end,
  --     nil, true, "Microsoft Teams"
  --   },
  -- }

  uh:init()
end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

function obj.init()
  init_hotkeys()
  init_url_handler()
end

return obj
