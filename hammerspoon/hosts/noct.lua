local obj = {}

function obj.init()
  local apptoggle = require('app_toggle')

  apptoggle:bind({'cmd', 'alt', 'ctrl'}, 'A', 'Activity Monitor')
  apptoggle:bind({'cmd', 'ctrl'}, '2', 'ChatGPT')
  apptoggle:bind({'cmd', 'ctrl'}, '4', 'Microsoft Edge')
  apptoggle:bind({'cmd', 'ctrl'}, 'A', 'Messages')
  apptoggle:bind({'cmd', 'ctrl'}, 'B', 'TablePlus')
  apptoggle:bind({'cmd', 'ctrl'}, 'C', 'Calendar')
  apptoggle:bind({'cmd', 'ctrl'}, 'D', 'Mailplane')
  apptoggle:bind({'cmd', 'ctrl'}, 'E', 'Emacs', '/Applications/Emacs.app')
  apptoggle:bind({'cmd', 'ctrl'}, 'F', 'Element Nightly')
  apptoggle:bind({'cmd', 'ctrl'}, 'S', 'Music')
  apptoggle:bind({'cmd', 'ctrl'}, 'T', 'Discord PTB')
  apptoggle:bind({'cmd', 'ctrl'}, 'W', 'WhatsApp')
  apptoggle:bind({'cmd', 'ctrl'}, 'X', 'Notion')
  apptoggle:bind({'cmd', 'ctrl'}, 'Z', 'Slack')
end

return obj
