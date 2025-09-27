--- === app_toggle ===
---
--- A Hammerspoon module for toggling between specified applications using
--- hotkeys.
---
--- This module allows you to bind a hotkey to switch focus between specific
--- applications and show/hide them.

local obj = {}

local function findRunningApp(name, path)
  for _, app in ipairs(hs.application.runningApplications()) do
    -- Get app name, removing any non-printable characters. This specifically
    -- fixes WhatsApp, who's name starts with a invisible UTF-8 LRM control
    -- character.
    local appName = app:name():gsub('[^%g+]', '')

    -- app:path() can error for certain pseudo-apps.
    -- Guard with pcall and skip on failure to keep iterating.
    local ok, appPath = pcall(function()
      return app:path()
    end)

    -- Skip apps that don't have a path or that don't end with ".app". If the
    -- path doesn't end with ".app", it's not likely to be a GUI app.
    if ok and appPath and appPath:match("%.app$") then
      if appName == name and (path == nil or path == appPath) then
        return app
      end
    end
  end
end

local focusTimes = {}

local function focusWatcher(_, eventType, appObject)
  if eventType == hs.application.watcher.activated then
    focusTimes[appObject:bundleID()] = hs.timer.secondsSinceEpoch()
  end
end

local appWatcher = hs.application.watcher.new(focusWatcher)
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

--- app_toggle:bind(mods, key, ...)
--- Method
--- Binds a hotkey to toggle between the specified applications.
---
--- Parameters:
---  * mods - A table with the modifiers for the hotkey
---  * key - A string with the key for the hotkey
---  * ... - A list of tables, each containing an application name and an
---          optional path
function obj:bind(mods, key, ...)
  local apps = { ... }
  if #apps > 1 then
    self:start()
  end

  hs.hotkey.bind(mods, key, self:toggleFn(apps))
end

--- app_toggle:toggleFn(apps)
--- Method
--- Creates and returns a function that toggles between the specified
--- applications via app_toggle:toggle() when called.
---
--- Parameters:
---  * apps - A table containing application configurations. Each configuration
---           is a table with an application name at the first index and an
---           optional path at the second index.
---
--- Returns:
---  * A function that, when called, toggles between the specified applications.
---
--- Example:
---  local toggleApps = obj:toggleFn({{"Firefox"}, {"Safari"}})
---  hs.hotkey.bind({"cmd", "ctrl"}, "b", toggleApps)
---
--- Notes:
---  * The returned function can be used as a callback for hotkey bindings or
---    other event-driven scenarios.
function obj:toggleFn(apps)
  return function()
    self:toggle(apps)
  end
end

--- app_toggle:toggle(apps)
--- Method
--- Toggles focus/visibility specified applications.
---
--- Parameters:
---  * apps - A table containing application configurations. Each configuration
---           is a table with an application name at the first index and an
---           optional path at the second index.
---
--- Notes:
---  * If none of the specified applications are running, the function attempts
---    to launch the first application in the list.
---  * If the most recently focused application in the list is the current
---    frontmost application, it will be hidden. Otherwise, the most recently
---    focused application will be brought to the front.
function obj:toggle(apps)
  local runningApps = {}
  local mostRecentApp = nil
  local mostRecentTime = -1

  for _, appInfo in ipairs(apps) do
    local name, path = appInfo[1], appInfo[2]
    local app = findRunningApp(name, path)
    if app then
      table.insert(runningApps, app)
      local focusTime = focusTimes[app:bundleID()] or 0
      if focusTime > mostRecentTime then
        mostRecentTime = focusTime
        mostRecentApp = app
      end
    end
  end

  if #runningApps == 0 then
    local app = apps[1]
    local status, err = pcall(hs.application.open, app[2] or app[1])
    if not status then
      hs.alert.show('Failed to open ' .. (app[2] or app[1]) .. ': ' .. err)
    end
    return
  end

  if not mostRecentApp then
    mostRecentApp = runningApps[1]
  end

  local frontMostApp = hs.application.frontmostApplication()
  if frontMostApp and mostRecentApp == frontMostApp then
    return mostRecentApp:hide()
  end

  return mostRecentApp:activate()
end

--- app_toggle:showAppInfo()
--- Method
--- Shows an alert with information about the frontmost application.
function obj:showAppInfo()
  local app = hs.application.frontmostApplication()

  hs.alert.show(app:name() .. " (" .. app:bundleID() .. ")")
  local ok, appPath = pcall(function()
    return app:path()
  end)
  if ok and appPath then
    hs.alert.show(appPath)
  else
    hs.alert.show("Path: <unavailable>")
  end
  hs.alert.show("PID: " .. app:pid())
end

-- the end
return obj
