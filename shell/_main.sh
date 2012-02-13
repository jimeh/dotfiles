#
# Main Shell Setup
#

# Set required path variables
DOTBIN="$DOTFILES/bin"

# Helper Functions
source "$DOTSHELL/helpers.sh"

# Ensure /usr/local/bin is before various system-paths
path_prepend "/usr/local/bin"

# Load bash or zsh specific init files
if [ -n "$BASH_VERSION" ]; then
    source "$DOTSHELL/bashrc.sh"
elif [ -n "$ZSH_VERSION" ]; then
    source "$DOTSHELL/zshrc.sh"
fi

# Aliases
source "$DOTSHELL/aliases.sh"

# Utils
source "$DOTSHELL/emacs.sh"
source "$DOTSHELL/git.sh"
source "$DOTSHELL/tmux.sh"

# Development
source "$DOTSHELL/nodejs.sh"
source "$DOTSHELL/python.sh"
source "$DOTSHELL/ruby.sh"

# Services
source "$DOTSHELL/services.sh"


#
# Environment Setup
#

# Editors
export EDITOR="emacsclient-wrapper"
export GEM_EDITOR="mate"

# Locale Setup
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# ensure bin and sbin paths from /usr/local are in PATH
path_add_after "/usr/local/sbin" "/usr/local/bin"

# Add user's bin directory to PATH
path_prepend "$HOME/bin"

# Add dotfiles' bin directory to PATH
path_prepend "$DOTBIN"

# Relative Paths - must be first in PATH
path_prepend "./node_modules/.bin" # Node.js
path_prepend "./vendor/bundle/bin" # Ruby Bundler

# Ensure TMPDIR is the same for local and remote ssh logins
if [[ $TMPDIR == "/var/folders/"* ]] || [[ $TMPDIR == "" ]]; then
    export TMPDIR="/tmp/user-$USER"
    mkdir -p "$TMPDIR"
fi
