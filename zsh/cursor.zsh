#
# Cursor Setup
#

if command-exists cursor-agent; then
  alias cu="cursor-agent"

  setup-completions cursor-agent "$(command-path cursor-agent)" \
    cursor-agent shell-integration zsh
fi

if command-exists cursor; then
  export EDITOR="cursor -w"
fi
