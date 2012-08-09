#
# Node.js
#

# Aliases
alias no="node"
alias np="npm"
alias ni="npm install"
alias ngi="npm install -g"
alias cof="coffee"


# Load nvm if it's available
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"

  # And it's shell completion
  if [ -f "$HOME/.nvm/bash_completion" ]; then
    source "$HOME/.nvm/bash_completion"
  fi
fi
