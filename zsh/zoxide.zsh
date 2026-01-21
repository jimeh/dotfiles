#
# zoxide Setup
#

if command-exists zoxide; then
  cached-eval "$(command-path zoxide)" zoxide init --cmd zox zsh

  # Use functions to allow regular zsh completion for cd to work.
  if command-exists __zoxide_z; then
    cd() { __zoxide_z "$@"; }
  fi
  if command-exists __zoxide_zi; then
    alias cdi='__zoxide_zi'
  fi
fi
