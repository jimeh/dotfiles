#
# Kubernetes Related
#

alias kc="kubectl"
alias hl="helm"
alias mk="minikube"

if command-exists kubectl; then
  # lazy-load kubectl completion
  _kubectl() {
    unset -f _kubectl
    eval "$(command kubectl completion zsh)"
  }

  zinit ice wait lucid as'program' from'gh-r'
  zinit light stackrox/kube-linter

  zinit ice wait lucid as'program' from'gh-r' mv'kind-* -> kind' \
    atclone'./kind completion zsh > _kind' atpull'%atclone'
  zinit light kubernetes-sigs/kind

  zinit ice wait lucid as'program' from'gh-r' \
    atclone'./flux completion zsh > _flux' atpull'%atclone'
  zinit light fluxcd/flux2

  zinit ice wait lucid as'program' from'gh-r' \
    atclone'./kustomize completion zsh > _kustomize' atpull'%atclone'
  zinit light kubernetes-sigs/kustomize

  zinit ice wait lucid as'program' from'gh-r' mv'kubeseal-* -> kubeseal'
  zinit light bitnami-labs/sealed-secrets
fi
