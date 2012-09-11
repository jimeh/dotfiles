# Aliases
alias tm="tmux"
alias tma="tm att"
alias tmn="tm new"
alias tml="tm ls"
alias tmm="tm -s main"

# Tmux Completion
if [ -f "/usr/local/etc/bash_completion.d/tmux" ]; then
  source "/usr/local/etc/bash_completion.d/tmux"
fi

# Tmuxifier
if [ -f "$DOTSHELL/tmux/tmuxifier" ]; then
  export TMUXIFIER="$DOTSHELL/tmux/tmuxifier"
  export TMUXIFIER_LAYOUT_PATH="$DOTFILES/private/tmux-layouts"
  [[ -s "$TMUXIFIER/init.sh" ]] && source "$TMUXIFIER/init.sh"

  alias m="tmuxifier"
  alias ms="tmuxifier load-session"
  alias mw="tmuxifier load-window"
fi
