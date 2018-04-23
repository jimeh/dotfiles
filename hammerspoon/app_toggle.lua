-- luacheck: read_globals hs

local obj = {}

function obj:bind (mods, key, name, path)
  hs.hotkey.bind(mods, key, self:toggleFn(name, path))
end

function obj:toggleFn (name, path)
  return function ()
    self:toggle(name, path)
  end
end

function obj:toggle (name, path)
  local app = self.findRunningApp(name, path)

  if app == nil then
    return hs.application.open(path or name)
  end

  if app == hs.application.frontmostApplication() then
    return app:hide()
  end

  return app:activate()
end

function obj.findRunningApp (name, path)
  for _, app in ipairs(hs.application.runningApplications()) do
    if app:name() == name and (path == nil or path == app:path()) then
      return app
    end
  end
end

-- the end
return obj
