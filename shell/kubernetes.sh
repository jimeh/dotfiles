#
# Kubernetes Related
#

alias kc="kubectl"
alias hl="helm"
alias mk="minikube"

export KUBECONFIG="$HOME/.kube/config:.kube/config"

if command -v kubectl > /dev/null; then
  eval "$(kubectl completion zsh)"
fi
