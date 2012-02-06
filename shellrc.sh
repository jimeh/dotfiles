#
# Shell Init
#

# Set path to root of dotfiles
if [ -n "${BASH_SOURCE[0]}" ]; then
    DOTFILES="`dirname \"${BASH_SOURCE[0]}\"`"
elif [ -n "$0" ]; then
    DOTFILES="`dirname \"$0\"`"
fi

# # Load main dotfiles
DOTSHELL="$DOTFILES/shell"
if [ -f "$DOTSHELL/_main.sh" ]; then
    source "$DOTSHELL/_main.sh"
fi

# # Setup and load private dotfiles
DOTPFILES="$DOTFILES/private"
if [ -f "$DOTPFILES/shellrc.sh" ]; then
    source "$DOTPFILES/shellrc.sh"
fi
