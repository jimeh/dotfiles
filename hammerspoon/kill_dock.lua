-- luacheck: read_globals hs

--- === kill_dock ===
---
--- Function to kill the Dock.

local obj = {}

--- kill_dock.killDock()
--- Function
--- Kills the Dock by executing `killall Dock`.
function obj.killDock()
  hs.alert.show('Restarting Dock...')
  hs.execute("killall Dock", true)
end

-- the end
return obj
