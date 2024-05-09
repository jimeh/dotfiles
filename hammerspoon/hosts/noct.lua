local obj = {}

--------------------------------------------------------------------------------
-- Global Hotkeys
--------------------------------------------------------------------------------

local apptoggle = require('app_toggle')

local function init_hotkeys()
  apptoggle:bind({ 'cmd', 'alt', 'ctrl' }, 'A', { 'Activity Monitor' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '2', { 'ChatGPT' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '4', { 'HuggingChat' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'A', { 'Messages' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'B', { 'Lens' }, { 'Sequel Pro' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'D', { 'Mail+ for Gmail' }, { 'Mimestream' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'E', { 'Emacs', '/Applications/Emacs.app' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'F', { 'Element' }, { 'Element Nightly' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'G', { 'Google Chrome' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'S', { 'Music' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'T', { 'Discord PTB' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'X', { 'Notion' }, { 'Obsidian' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'Z', { 'Slack' })

  apptoggle:bind({ 'cmd', 'ctrl' }, 'C',
    { 'Calendar' },
    { 'Google Calendar' },
    { 'Notion Calendar' }
  )

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
  uh.default_handler = uh.browsers.safari
  uh.url_patterns    = {
    {
      { "%://meet.google.com/" }, uh.browsers.chrome, nil,
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
