#
# Emacs
#

# Depends on EMACS and EMACSCLIENT environment variables set in ~/.zshenv

# Enforce 24-bit color mode if available
if command-exists toe && toe | grep '24bit' &> /dev/null; then
  FULL_COLOR_TERM="$(toe | grep '24bit' | head -n1 | awk '{ print $1 }')"
  alias emacsgui="env TERM=$FULL_COLOR_TERM $EMACS"
  alias emacs="env TERM=$FULL_COLOR_TERM $EMACS -nw"
  alias emacsclient="env TERM=$FULL_COLOR_TERM $EMACSCLIENT"
else
  alias emacsgui="$EMACS"
  alias emacs="$EMACS -nw"
  alias emacsclient="$EMACSCLIENT"
fi

# add doom-emacs' bin directory to path if it exists
path_prepend "$HOME/.config/doom-emacs/bin"

# install emacs-sandbox.sh
zinit light-mode wait lucid as'program' pick'emacs-sandbox.sh' from'gh' \
  for @alphapapa/emacs-sandbox.sh

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
