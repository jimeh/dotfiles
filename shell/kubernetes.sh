#
# Kubernetes Related
#

alias kc="kubectl"
alias hl="helm"

if command -v kubectl > /dev/null; then
  eval "$(kubectl completion zsh)"
fi
