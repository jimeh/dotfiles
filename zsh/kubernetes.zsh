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

  switch() {
    unset -f switch
    source "$(brew --prefix switch)/switch.sh"
    switch "$@"
  }

  zinit light-mode wait lucid as'program' from'gh-r' \
    for @stackrox/kube-linter

  if ! kubectl krew &> /dev/null; then
    krew-bin() {
      echo "krew-$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e \
        's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' \
        -e 's/aarch64$/arm64/')"
    }

    zinit light-mode wait lucid as'null' from'gh-r' bpick'krew.tar.gz' \
      atclone'KREW='"'$(krew-bin)'"' && ./$KREW install krew' \
      for @kubernetes-sigs/krew

    export KREW_ROOT="$HOME/.krew"
    path_append "${KREW_ROOT}/bin"
  fi

  zinit light-mode wait lucid as'program' from'gh-r' mv'kind-* -> kind' \
    atclone'./kind completion zsh > _kind' atpull'%atclone' \
    for @kubernetes-sigs/kind

  zinit light-mode wait lucid as'program' from'gh-r' \
    atclone'./flux completion zsh > _flux' atpull'%atclone' \
    for @fluxcd/flux2

  zinit light-mode wait lucid as'program' from'gh-r' \
    atclone'./kustomize completion zsh > _kustomize' atpull'%atclone' \
    for @kubernetes-sigs/kustomize

  zinit light-mode wait lucid as'program' from'gh-r' pick'kubeseal' \
    for @bitnami-labs/sealed-secrets

  zinit light-mode wait lucid as'program' from'gh-r' mv'argocd-* -> argocd' \
    atclone'./argocd completion zsh > _argocd' atpull'%atclone' \
    for @argoproj/argo-cd
fi
