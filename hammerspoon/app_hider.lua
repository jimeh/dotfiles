--- === app_hider ===
---
--- A Hammerspoon module which hides specified applications when they are
--- deactivated (lose focus).

local obj = {}
local autoHideApps = {}

local function shouldAutoHide(appName)
  for _, name in ipairs(autoHideApps) do
    if appName == name then
      return true
    end
  end
  return false
end

local function appWatcherCallback(appName, eventType, appObject)
  if eventType == hs.application.watcher.deactivated and shouldAutoHide(appName) then
    appObject:hide()
  end
end

local appWatcher = hs.application.watcher.new(appWatcherCallback)
obj.started = false

function obj:start()
  if obj.started then
    return
  end

  appWatcher:start()
  obj.started = true
end

function obj:stop()
  if not obj.started then
    return
  end

  appWatcher:stop()
  obj.started = false
end

--- app_hider:autoHide(appName)
--- Method
--- Adds an application to the auto-hide list.
---
--- Parameters:
--- * appName - A string with the name of the application to auto-hide.
function obj:autoHide(appName)
  if not appName or type(appName) ~= "string" then
    print("Error: Invalid app name provided to autoHide.")
    return
  end

  obj:start() -- Ensure the watcher is running

  -- Prevent duplicates in the autoHideApps table
  for _, name in ipairs(autoHideApps) do
    if name == appName then
      print("App already in auto-hide list: " .. appName)
      return
    end
  end

  table.insert(autoHideApps, appName)
end

--- app_hider:remove(appName)
--- Method
--- Removes an application from the auto-hide list.
---
--- Parameters:
--- * appName - A string with the name of the application to remove from the
---             auto-hide list.
function obj:remove(appName)
  for i, name in ipairs(autoHideApps) do
    if name == appName then
      table.remove(autoHideApps, i)
      break
    end
  end

  -- Stop the watcher if the list is empty
  if #autoHideApps == 0 and obj.started then
    obj:stop()
  end
end

return obj
