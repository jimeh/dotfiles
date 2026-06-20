#
# noa
#

# Keep pinentry prompts attached to the current terminal, including tmux panes
# and SSH sessions.
if command-exists gpg-connect-agent; then
  export GPG_TTY="$(tty)"
  gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
fi
