# Aliases
alias tm="tmux"
alias tma="tm att"
alias tmn="tm new"
alias tml="tm ls"
alias tmm="tmn -s main"

# Custom Install
if [ -d "/opt/tmux/bin" ]; then
  path_prepend "/opt/tmux/bin"
fi

# Tmux Completion
if [ -f "/usr/local/etc/bash_completion.d/tmux" ]; then
  source "/usr/local/etc/bash_completion.d/tmux"
fi

# Tmuxifier
if [ -d "$DOTSHELL/tmux/tmuxifier" ]; then
  path_prepend "$DOTSHELL/tmux/tmuxifier/bin"
  eval "$(tmuxifier init -)"

  alias m="tmuxifier"
  alias ms="tmuxifier load-session"
  alias mw="tmuxifier load-window"
  alias mm="tmuxifier load-session main"
fi
