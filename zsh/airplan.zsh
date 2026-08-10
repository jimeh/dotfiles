#
# airplan
#

if command-exists airplan; then
  setup-completions airplan "$(mise-which airplan)" airplan completion zsh
fi
