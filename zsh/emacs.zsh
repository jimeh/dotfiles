#
# Emacs
#

# macOS systems
if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
  alias emacs="env TERM=screen-24bit /Applications/Emacs.app/Contents/MacOS/Emacs -nw"
fi

if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
  alias emacsclient="env TERM=screen-24bit /Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi
