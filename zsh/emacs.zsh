#
# Emacs
#

# macOS systems
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
    alias emacsgui="env TERM=screen-24bit /Applications/Emacs.app/Contents/MacOS/Emacs"
    alias emacs="env TERM=screen-24bit /Applications/Emacs.app/Contents/MacOS/Emacs -nw"
  fi

  if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
    alias emacsclient="env TERM=screen-24bit /Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
  fi
fi

if [[ "$OSTYPE" == "linux"* ]]; then
  alias emacs="env TERM=screen-24bit emacs -nw"
  alias emacsclient="env TERM=screen-24bit emacsclient"
fi
