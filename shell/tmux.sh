# Aliases
alias tm="tmux"
alias tma="tm att"
alias tmn="tm new"
alias tml="tm ls"

# Tmux Completion
if [ -f "/usr/local/etc/bash_completion.d/tmux" ]; then
    source "/usr/local/etc/bash_completion.d/tmux"
fi
