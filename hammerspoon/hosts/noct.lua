local obj = {}

--------------------------------------------------------------------------------
-- Global Hotkeys
--------------------------------------------------------------------------------

local apptoggle = require('app_toggle')
local apphider = require('app_hider')

local function init_hotkeys()
  hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'S', apptoggle.showAppInfo)

  apptoggle:bind({ 'cmd', 'alt', 'ctrl' }, 'A', { 'Activity Monitor' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '2', { 'ChatGPT' })
  apptoggle:bind({ 'cmd', 'ctrl' }, '4', { 'Claude' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'A', { 'Messages' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'B', { 'TablePlus' }, { 'Sequel Pro' }, { 'Lens' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'D', { 'Mail+ for Gmail' }, { 'Mimestream' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'E', { 'Cursor' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'F', { 'GitButler' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'G', { 'Emacs', '/Applications/Emacs.app' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'T', { 'Discord PTB' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'X', { 'Notion' }, { 'Obsidian' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'W', { 'WhatsApp' })
  apptoggle:bind({ 'cmd', 'ctrl' }, 'Z', { 'Slack' })

  apptoggle:bind({ 'cmd', 'ctrl' }, 'C',
    { 'Calendar' },
    { 'Google Calendar' },
    { 'Notion Calendar' }
  )

  -- -- Use Warp as my primary terminal application.
  -- apptoggle:bind({ 'cmd', 'ctrl' }, 'R', { 'Warp' })
  -- apphider:autoHide('Warp') -- auto-hide Warp when it loses focus

  -- Use Ghostty as my primary terminal application.
  -- apptoggle:bind({ 'cmd', 'ctrl' }, 'R', { 'Ghostty' })
  -- apphider:autoHide('Ghostty') -- auto-hide Ghostty when it loses focus
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
--   -- uh.url_redir_decoders = {
--   --   {
--   --     "MS Teams links",
--   --     function(_, _, params, fullUrl)
--   --       if params.url then
--   --         return params.url
--   --       else
--   --         return fullUrl
--   --       end
--   --     end,
--   --     nil, true, "Microsoft Teams"
--   --   },
--   -- }

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
