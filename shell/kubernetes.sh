#
# Kubernetes Related
#

alias kc="kubectl"
alias hl="helm"
alias mk="minikube"

if command -v kubectl > /dev/null; then
  eval "$(kubectl completion zsh)"
fi
