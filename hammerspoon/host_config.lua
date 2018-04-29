local obj = {}

function obj:init()
  local env = require('env')
  local conf_file = "hosts/" .. env.hostname .. ".lua"
  local conf_req = "hosts." .. env.hostname

  if self.file_exists(conf_file) then
    print("loading host config: " .. conf_file)
    local conf_module = require(conf_req)
    conf_module:init()
  end
end

function obj.file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

return obj
