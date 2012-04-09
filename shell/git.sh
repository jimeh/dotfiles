#
# Git
#

# Author name
export GIT_AUTHOR_NAME="`git config --global user.name`"
export GIT_AUTHOR_EMAIL="`git config --global user.email`"

# Aliases
alias g="git"
alias gi="git"
alias ga="git add"
alias gs="git status"
alias gai="git add -i"
alias gp="git push"
alias gf="git fetch"
alias gd="git difftool"
alias gpl="git pull --rebase"
alias gix="gitx"
alias gx="gitx"

# Git Completion
if [ -f "/usr/local/etc/bash_completion.d/git-completion.bash" ]; then
    source "/usr/local/etc/bash_completion.d/git-completion.bash"
fi

# Only needed for Bash. Zsh is much smarter with it's auto-completion ^_^
if [ -n "$BASH_VERSION" ]; then
    complete -o default -o nospace -F _git g
    complete -o default -o nospace -F _git gi
fi
