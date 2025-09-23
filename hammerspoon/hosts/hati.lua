local obj = {}

--------------------------------------------------------------------------------
-- Global Hotkeys
--------------------------------------------------------------------------------

local apptoggle = require('app_toggle')
local apphider = require('app_hider')

local function init_hotkeys()
  hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'S', apptoggle.showAppInfo)

  apptoggle:bind({ 'cmd', 'alt', 'ctrl' }, 'A', { 'Activity Monitor' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '2', { 'Open WebUI' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '4', { 'Claude' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'A', { 'Argo CD' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'B', { 'TablePlus' }, { 'Lens' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'D', { 'Gmail' }, { 'Notion Mail' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'E', { 'Cursor' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'F', { 'GitButler' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'G', { 'Emacs', '/Applications/Emacs.app' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'T', { 'TeamSpeak 3', '/Applications/TeamSpeak 3 Client.app' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'X', { 'Notion' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'Z', { 'Slack' })

  apptoggle:bind({ 'cmd', 'ctrl' }, 'C',
    { 'Notion Calendar' },
    { 'Calendar' },
    { 'Google Calendar' }
  )

  apptoggle:bind({ 'cmd', 'ctrl' }, 'W',
    { 'Code', '/Applications/Visual Studio Code.app' },
    { 'Code - Insiders', '/Applications/Visual Studio Code - Insiders.app' }
  )

  -- Use Ghostty as my primary terminal application.
  apptoggle:bind({ 'cmd', 'ctrl' }, 'R', { 'Ghostty' })
  apphider:autoHide('Ghostty') -- auto-hide Ghostty when it loses focus

  -- Use Warp as my primary terminal application.
  -- apptoggle:bind({ 'cmd', 'ctrl' }, 'R', { 'Warp' })
  -- apphider:autoHide('Warp') -- auto-hide Warp when it loses focus
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
