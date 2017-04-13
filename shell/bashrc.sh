#
# Bash Init
#

# Deterimine current directory
DOTBASH="$DOTSHELL/bash"

# bash-completion
if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi

source "$DOTBASH/prompt.sh"
# source "$DOTBASH/bash-ido.sh" # Disabled for making life complicated
