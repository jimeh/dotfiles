#
# Kubernetes Related
#

alias kc="kubectl"
alias hl="helm"
alias mk="minikube"

if (( $+commands[kubectl] )); then
  eval "$(kubectl completion zsh)"
fi
