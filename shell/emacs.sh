#
# Emacs
#

# OS X systems.
if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
  alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
fi

if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
  alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi

# *nix systems.
if [ -d "/opt/emacs/bin" ]; then
  path_append "/opt/emacs/bin"
fi
