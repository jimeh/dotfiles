-- luacheck: read_globals hs spoon

-- Reload config hotkey
hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'R', hs.reload)
hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'C', hs.toggleConsole)

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
spoon.RoundedCorners.radius = 12
spoon.RoundedCorners:start()

-- Automatically pause music when headphones are unplugged.
hs.loadSpoon('HeadphoneAutoPause')
spoon.HeadphoneAutoPause.autoResume = false
spoon.HeadphoneAutoPause:start()

--------------------------------------------------------------------------------
-- Host specific configuration
--------------------------------------------------------------------------------

local hostconfig = require('host_config')
hostconfig:init()

--------------------------------------------------------------------------------
-- Window management
--------------------------------------------------------------------------------

local wm = require('window_management')
wm:init()

--------------------------------------------------------------------------------
-- Misc. Helpers
--------------------------------------------------------------------------------

local kd = require('kill_dock')
hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'D', kd.killDock)

--------------------------------------------------------------------------------
-- The End
--------------------------------------------------------------------------------
hs.alert.show('Hammerspoon loaded')
