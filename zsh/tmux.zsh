# Aliases
alias tm="tmux"
alias tma="tm att"
alias tmn="tm new"
alias tml="tm ls"
alias tmm="tmn -s main"

# Tmux Completion
if [ -f "/usr/local/etc/bash_completion.d/tmux" ]; then
  source "/usr/local/etc/bash_completion.d/tmux"
fi

# Tmuxifier
if [ -d "$DOTFILES/tmux/tmuxifier" ]; then
  alias m="tmuxifier"
  alias ms="tmuxifier load-session"
  alias mw="tmuxifier load-window"
  alias mm="tmuxifier load-session main"

  # lazy-load tmuxifier
  tmuxifier() {
    load-tmuxifier
    tmuxifier "$@"
  }

  _tmuxifier() {
    load-tmuxifier
    _tmuxifier "$@"
  }

  compctl -K _tmuxifier tmuxifier

  load-tmuxifier() {
    # unset lazy-load functions
    unset -f load-tmuxifier _tmuxifier tmuxifier

    if [ -d "$DOTPFILES/tmux-layouts" ]; then
      export TMUXIFIER_LAYOUT_PATH="$DOTPFILES/tmux-layouts"
    else
      export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
    fi

    path_prepend "$DOTFILES/tmux/tmuxifier/bin"
    eval "$(command tmuxifier init -)"
  }
fi

use-tmuxifier-dev() {
  path_prepend "$HOME/Projects/tmuxifier/bin"
  path_remove "$DOTFILES/tmux/tmuxifier/bin"
  export TMUXIFIER="$HOME/Projects/tmuxifier"
}
