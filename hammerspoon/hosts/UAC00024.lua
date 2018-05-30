local obj = {}

function obj.init()
  local apptoggle = require('app_toggle')

  apptoggle:bind({'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'Sequel Pro')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Paw')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Mail')
  apptoggle:bind({'cmd', 'ctrl'}, 'E', 'Emacs', '/Applications/Emacs.app')
  apptoggle:bind({'cmd', 'ctrl'}, 'G', 'Stride')
  apptoggle:bind({'cmd', 'ctrl'}, 'S', 'Skype for Business')
  apptoggle:bind({'cmd', 'ctrl'}, 'X', 'Calendar')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Microsoft Teams')
end

return obj
