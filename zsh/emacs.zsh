#
# Emacs
#

# macOS systems
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
    export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
    alias emacsgui="env TERM=screen-24bit $EMACS"
    alias emacs="env TERM=screen-24bit $EMACS -nw"
  fi

  if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
    alias emacsclient="env TERM=screen-24bit /Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
  fi
fi

# Linux systems
if [[ "$OSTYPE" == "linux"* ]]; then
  alias emacs="env TERM=screen-24bit emacs -nw"
  alias emacsclient="env TERM=screen-24bit emacsclient"
fi

# add doom-emacs' bin directory to path if it exists
path_prepend "$HOME/.config/doom-emacs/bin"
