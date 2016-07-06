#
# Environment Setup
#

# Editors
export EDITOR="emacsclient-wrapper"
export GEM_EDITOR="mate"

# Locale Setup
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# GCC 4.2 via Homebrew
# export CC=/usr/local/bin/gcc-4.2

# Android SDK
export ANDROID_SDK_ROOT="/usr/local/Cellar/android-sdk/r20.0.1"
export ANDROID_HOME="/usr/local/opt/android-sdk"

# ensure bin and sbin paths from /usr/local are in PATH
path_add_after "/usr/local/sbin" "/usr/local/bin"

# ensure bin and sbin paths from /usr are in PATH
path_add_after "/usr/sbin" "/usr/bin"

# Add user's bin directory to PATH
path_prepend "$HOME/bin"

# Add dotfiles' bin directory to PATH
path_prepend "$DOTBIN"

# Ensure TMPDIR is the same for local and remote ssh logins
if [[ $TMPDIR == "/var/folders/"* ]] || [[ $TMPDIR == "" ]]; then
  export TMPDIR="/tmp/user-$USER"
  mkdir -p "$TMPDIR"
fi
