#
# Kubernetes Related
#

alias kc="kubectl"
alias hl="helm"
alias mk="minikube"

if command-exists kubectl; then
  # lazy-load kubectl setup
  _kubectl() {
    unset -f _kubectl
    eval "$(command kubectl completion zsh)"
  }
fi
