local obj = {}

function obj.init()
  local apptoggle = require('app_toggle')

  apptoggle:bind({'cmd', 'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, '4', 'Skitch')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'Sequel Pro')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Mail')
  apptoggle:bind({'cmd', 'ctrl'}, 'E', 'Emacs', '/Applications/Emacs.app')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Calendar')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Microsoft Teams')
end

return obj
