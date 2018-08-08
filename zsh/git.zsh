#
# Git
#

# Aliases
alias g="git"
alias gi="git"
alias ga="git add"
alias gb="git branch"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gr="git remote"
alias gs="git status"
alias gai="git add -i"
alias gp="git push"
alias gf="git fetch"
alias gd="git difftool"
alias gpl="git pull --rebase"
alias gix="gitx"
alias gx="gitx"

# Git Completion
if [ -d "/usr/local/share/zsh/site-functions" ]; then
  fpath=("/usr/local/share/zsh/site-functions" "${fpath[@]}")
fi
