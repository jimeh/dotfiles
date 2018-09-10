local obj = {}

function obj.init()
  local apptoggle = require('app_toggle')

  apptoggle:bind({'cmd', 'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, '1', 'Microsoft To-Do')
  apptoggle:bind({'cmd', 'ctrl'}, '4', 'Skitch')
  apptoggle:bind({'cmd', 'ctrl'}, 'A', 'YakYak')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'Postico')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Medis')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Wavebox')
  apptoggle:bind({'cmd', 'ctrl'}, 'E', 'Emacs', '/Applications/Emacs.app')
  apptoggle:bind({'cmd', 'ctrl'}, 'F', 'Messenger')
  apptoggle:bind({'cmd', 'ctrl'}, 'G', 'Microsoft Teams')
  apptoggle:bind({'cmd', 'ctrl'}, 'S', 'Keybase')
  apptoggle:bind({'cmd', 'ctrl'}, 'T', 'IRCCloud')
  apptoggle:bind({'cmd', 'ctrl'}, 'W', 'WhatsApp')
  apptoggle:bind({'cmd', 'ctrl'}, 'X', 'Calendar')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Slack')
end

return obj
