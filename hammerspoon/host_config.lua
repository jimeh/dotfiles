local function require_file(path)
  local ok, module = pcall(loadfile, path)
  return (ok and module and module() or nil)
end

local obj = {}

function obj:init()
  local hostname = hs.host.localizedName()
  local conf_file = 'hosts/' .. hostname .. '.lua'
  local hostmod = require_file(conf_file)

  if hostmod then
    print('loading host config: ' .. conf_file)
    hostmod.init()
  end
end

return obj
