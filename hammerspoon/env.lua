local obj = {
  hostname = nil
}

function obj:init()
  self.hostname = self.getHostname()
end

function obj:getHostname()
  local f = io.popen ("hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  return hostname
end

return obj
