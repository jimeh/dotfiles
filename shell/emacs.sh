#
# Emacs
#

if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
    alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
fi
if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
    alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi
