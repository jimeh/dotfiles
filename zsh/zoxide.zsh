#
# zoxide Setup
#

if command-exists zoxide; then
  cached-eval "$(command-path zoxide)" zoxide init --cmd zox zsh

  # Use functions to allow regular zsh completion for cd to work.
  if command -v __zoxide_z &>/dev/null; then
    cd() { __zoxide_z "$@"; }
  fi
  if command -v __zoxide_zi &>/dev/null; then
    alias cdi='__zoxide_zi'

    # ZLE widget for interactive directory picker.
    zoxide-interactive-widget() {
      __zoxide_zi </dev/tty
      zle reset-prompt
    }
    zle -N zoxide-interactive-widget
    bindkey '^X^F' zoxide-interactive-widget
  fi
fi
