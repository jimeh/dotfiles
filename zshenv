#
# ZSH Environment Setup
#

# Ensure values in path variable are unique.
typeset -U path

# Path helpers
path_list () {
  print -l "${(@)path}"
}

path_remove () {
  path=("${(@)path:#$1}")
}

path_append () {
  if [ -d "$1" ]; then
    path+="$1"
  fi
}

path_prepend () {
  if [ -d "$1" ]; then
    path=("$1" "${(@)path:#$1}")
  fi
}


# ==============================================================================
# System Environment Setup
# ==============================================================================

DOTFILES="$HOME/.dotfiles"
DOTBIN="$DOTFILES/bin"
DOTZSH="$DOTFILES/zsh"

# Editors
export EDITOR="emacsclient-wrapper"
export GEM_EDITOR="mate"

# Locale Setup
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Ensure TMPDIR is the same for local and remote ssh logins
if [[ "$TMPDIR" == "/var/folders/"* ]] || [[ "$TMPDIR" == "" ]]; then
  export TMPDIR="/tmp/user-$USER"
  mkdir -p "$TMPDIR"
fi

# Ensure basic systems paths are in desired order.
path_prepend "/sbin"
path_prepend "/bin"
path_prepend "/usr/sbin"
path_prepend "/usr/bin"
path_prepend "/usr/local/sbin"
path_prepend "/usr/local/bin"

# Add dotfiles' bin directory to PATH
path_prepend "$DOTBIN"

# Add user's bin directory to PATH
path_prepend "$HOME/bin"


# ==============================================================================
# Private Dotfiles Environment
# ==============================================================================

DOTPFILES="$DOTFILES/private"

if [ -f "$DOTPFILES/zshenv" ]; then
  source "$DOTPFILES/zshenv"
fi

# ==============================================================================
# Third-party Environment Setup
# ==============================================================================

# Android SDK environment setup.
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path_append "$ANDROID_HOME/emulator"
  path_append "$ANDROID_HOME/tools"
  path_append "$ANDROID_HOME/tools/bin"
  path_append "$ANDROID_HOME/platform-tools"
fi

# Flutter environment setup
path_append "/opt/flutter/bin"
path_append "/opt/flutter/bin/cache/dart-sdk/bin"

# Use gnu-getop if available
path_prepend "/usr/local/opt/gnu-getopt/bin"

# Go (golang) environment setup
export GOPATH="$HOME/.go"
path_prepend "$GOPATH/bin"

# Homebrew setup
export HOMEBREW_NO_ANALYTICS=1

# Kubernetes setup
export KUBECONFIG="$HOME/.kube/config:.kube/config"

# Use custom emacs install if available
path_prepend "/opt/emacs/bin"

# Use custom tmux install if available
path_prepend "/opt/tmux/bin"

# Ruby setup
path_prepend "$HOME/.rbenv/shims"

# Rust setup
path_prepend "$HOME/.cargo/bin"

# ==============================================================================
# Local Overrides
# ==============================================================================

if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
