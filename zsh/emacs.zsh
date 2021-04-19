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

# Setup vterm if shell is within vterm inside Emacs.
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
  if [[ -n "${EMACS_VTERM_PATH}" ]] &&
    [[ -f "${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh" ]]; then
    source "${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh"
  fi

  # Some commands to invoke emacs functions
  find-file() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
  }

  say() {
    vterm_cmd message "%s" "$*"
  }
fi
