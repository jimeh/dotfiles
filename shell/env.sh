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

# ensure bin and sbin paths from /usr are in PATH
path_add_after "/usr/sbin" "/usr/bin"

# Add user's bin directory to PATH
path_prepend "$HOME/bin"

# Add dotfiles' bin directory to PATH
path_prepend "$DOTBIN"
