local obj = {}

function obj.init()
  local apptoggle = require('app_toggle')

  apptoggle:bind({'cmd', 'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, '1', 'Microsoft To-Do')
  apptoggle:bind({'cmd', 'ctrl'}, '4', 'Skitch')
  apptoggle:bind({'cmd', 'ctrl'}, 'A', 'Messages')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'ClickUp')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Calendar')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Fastmate')
  apptoggle:bind({'cmd', 'ctrl'}, 'E', 'Emacs', '/Applications/Emacs.app')
  apptoggle:bind({'cmd', 'ctrl'}, 'F', 'Element')
  apptoggle:bind({'cmd', 'ctrl'}, 'S', 'Music')
  apptoggle:bind({'cmd', 'ctrl'}, 'T', 'Discord')
  apptoggle:bind({'cmd', 'ctrl'}, 'W', 'WhatsApp')
  apptoggle:bind({'cmd', 'ctrl'}, 'X', 'Reminders')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Slack')
end

return obj
