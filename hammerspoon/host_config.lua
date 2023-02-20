local host = require('hs.host')

local function require_file(path)
  local modulename = string.gsub(path, "/", "."):gsub("%.lua$", "")
  local ok, module = pcall(require, modulename)

  return (ok and module or nil)
end

local obj = {}

function obj:init()
  local hostname = host.localizedName()
  local conf_file = "hosts/" .. hostname .. ".lua"
  local hostmod = require_file(conf_file)

  if hostmod then
    print("loading host config: " .. conf_file)
    hostmod.init()
  end
end

return obj
