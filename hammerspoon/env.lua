local obj = {
  hostname = nil
}

function obj.getHostname()
  local f = io.popen ("hostname -s")
  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  return hostname
end

obj.hostname = obj.getHostname()
return obj
