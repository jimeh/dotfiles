local obj = {}

function obj.init()
  local apptoggle = require('app_toggle')

  apptoggle:bind({'cmd', 'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, '1', 'Microsoft To-Do')
  apptoggle:bind({'cmd', 'ctrl'}, '4', 'Skitch')
  apptoggle:bind({'cmd', 'ctrl'}, 'A', 'Messages')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'Sequel Pro')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Calendar')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Kiwi for Gmail Lite')
  apptoggle:bind({'cmd', 'ctrl'}, 'E', 'Emacs', '/Applications/Emacs.app')
  apptoggle:bind({'cmd', 'ctrl'}, 'F', 'Messenger')
  apptoggle:bind({'cmd', 'ctrl'}, 'S', 'Music')
  apptoggle:bind({'cmd', 'ctrl'}, 'T', 'Discord')
  apptoggle:bind({'cmd', 'ctrl'}, 'W', 'WhatsApp')
  apptoggle:bind({'cmd', 'ctrl'}, 'X', 'Things', '/Applications/Things3.app')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Slack')
end

return obj
