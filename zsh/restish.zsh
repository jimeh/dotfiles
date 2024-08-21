#
# restish Setup
#

if command-exists restish; then
  setup-completions restish "$(command-path restish)" restish completion zsh
fi
