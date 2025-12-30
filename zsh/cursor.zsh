#
# Cursor Setup
#

if command-exists cursor-agent; then
  setup-completions cursor-agent "$(command-path cursor-agent)" \
    cursor-agent shell-integration zsh
fi

if command-exists cursor; then
  export EDITOR="cursor -w"
  alias cu="cursor"
  alias e="cursor -w"
fi
