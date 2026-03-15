#
# iTerm2 environment setup.
#

# Load iTerm2 shell integration.
if [ -n "$ITERM_SESSION_ID" ] &&
   [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi
