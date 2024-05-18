#
# zoxide Setup
#

if command-exists zoxide; then
  cached-eval "$(command -v zoxide)" zoxide init --cmd zox zsh

  # Use functions to allow regular zsh completion for cd to work.
  cd() { __zoxide_z "$@"; }
  alias cdi='__zoxide_zi'
fi
