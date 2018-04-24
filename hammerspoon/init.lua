-- luacheck: read_globals hs spoon

-- Reload config hotkey
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'R', hs.reload)
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'C', hs.toggleConsole)

--------------------------------------------------------------------------------
-- Environment
--------------------------------------------------------------------------------

local env = require('env')
env:init()

--------------------------------------------------------------------------------
-- Set Hammerspoon options
--------------------------------------------------------------------------------

hs.autoLaunch(true)
hs.consoleOnTop(true)
hs.dockIcon(false)
hs.menuIcon(true)
hs.console.alpha(0.90)
hs.console.behaviorAsLabels { 'moveToActiveSpace' }

--------------------------------------------------------------------------------
-- Load Spoons
--------------------------------------------------------------------------------

-- Draw pretty rounded corners on all screens.
hs.loadSpoon('RoundedCorners')
spoon.RoundedCorners:start()

-- Automatically pause music when headphones are unplugged.
hs.loadSpoon('HeadphoneAutoPause')
spoon.HeadphoneAutoPause.autoResume = false
spoon.HeadphoneAutoPause:start()

--------------------------------------------------------------------------------
-- Application toggles
--------------------------------------------------------------------------------

local apptoggle = require('app_toggle')

apptoggle:bind({'cmd', 'ctrl'}, 'E', 'Emacs', '/Applications/Emacs.app')
apptoggle:bind({'cmd', 'ctrl'}, 'X', 'Calendar')

if env.hostname == "UAC00024" then
  apptoggle:bind({'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'Sequel Pro')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Paw')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Mail')
  apptoggle:bind({'cmd', 'ctrl'}, 'G', 'Slack')
  apptoggle:bind({'cmd', 'ctrl'}, 'S', 'Skype for Business')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Stride')
else
  apptoggle:bind({'cmd', 'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, '4', 'Skitch')
  apptoggle:bind({'cmd', 'ctrl'}, 'A', 'YakYak')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'Portico')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Medis')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Wavebox')
  apptoggle:bind({'cmd', 'ctrl'}, 'F', 'Messenger')
  apptoggle:bind({'cmd', 'ctrl'}, 'G', 'Stride')
  apptoggle:bind({'cmd', 'ctrl'}, 'S', 'Skype')
  apptoggle:bind({'cmd', 'ctrl'}, 'T', 'IRCCloud')
  apptoggle:bind({'cmd', 'ctrl'}, 'W', 'WhatsApp')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Slack')
end

--------------------------------------------------------------------------------
-- Window management
--------------------------------------------------------------------------------

local wm = require('window_management')
wm:init()

--------------------------------------------------------------------------------
-- The End
--------------------------------------------------------------------------------
hs.alert.show('Hammerspoon loaded')
