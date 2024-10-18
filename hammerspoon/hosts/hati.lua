local obj = {}

--------------------------------------------------------------------------------
-- Global Hotkeys
--------------------------------------------------------------------------------

local apptoggle = require('app_toggle')

local function init_hotkeys()
  hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'S', apptoggle.showAppInfo)

  apptoggle:bind({ 'cmd', 'alt', 'ctrl' }, 'A', { 'Activity Monitor' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '2', { 'Open WebUI' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '4', { 'Claude' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'A', { 'ArgoCD' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'B', { 'TablePlus' }, { 'Lens' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'D', { 'Mail' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'E', { 'Emacs', '/Applications/Emacs.app' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'T', { 'TeamSpeak 3', '/Applications/TeamSpeak 3 Client.app' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'X', { 'Obsidian' }, { 'Notion' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'Z', { 'Slack' })

  apptoggle:bind({ 'cmd', 'ctrl' }, 'C',
    { 'Calendar' },
    { 'Google Calendar' },
    { 'Notion Calendar' }
  )

  apptoggle:bind({ 'cmd', 'ctrl' }, 'W',
    { 'Code - Insiders', '/Applications/Visual Studio Code - Insiders.app' }
  )
  apptoggle:bind({ 'cmd', 'ctrl' }, '1',
    { 'Code', '/Applications/Visual Studio Code.app' }
  )
end

--------------------------------------------------------------------------------
-- URL Handling
--------------------------------------------------------------------------------

-- local uh = require('url_handler')

-- local function init_url_handler()
--   uh.default_handler = uh.browsers.arc
--   uh.url_patterns    = {
--     {
--       { "%://meet.google.com/" }, uh.browsers.chrome, nil,
--     }
--   }

--   uh:init()
-- end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

function obj.init()
  init_hotkeys()
  -- init_url_handler()
end

return obj
