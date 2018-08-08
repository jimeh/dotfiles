#
# Kubernetes Related
#

alias kc="kubectl"
alias hl="helm"
alias mk="minikube"

export KUBECONFIG="$HOME/.kube/config:.kube/config"

if [ $commands[kubectl] ]; then
  eval "$(kubectl completion zsh)"
fi
