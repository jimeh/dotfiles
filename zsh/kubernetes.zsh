#
# Kubernetes Related
#

alias kc="kubectl"
alias kx="kubectx"
alias kn="kubens"
alias hl="helm"
alias mk="minikube"

if command-exists kubectl; then
  setup-completions kubectl "$(command-path kubectl)" kubectl completion zsh

  export KREW_ROOT="$HOME/.krew"
  path_append "${KREW_ROOT}/bin"

  if ! command-exists kubectl-krew; then
    krew-bin-name() {
      echo "krew-$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e \
        's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' \
        -e 's/aarch64$/arm64/')"
    }

    zinit light-mode wait lucid as'null' from'gh-r' bpick"$(krew-bin-name)*" \
      atclone'KREW='"'$(krew-bin-name)'"' && ./$KREW install krew' \
      for @kubernetes-sigs/krew

    export KREW_ROOT="$HOME/.krew"
    path_append "${KREW_ROOT}/bin"
  fi
fi

_setup-kubectx-completion() {
  local cmd="$1"
  local dir="$HOME/.local/share/mise/installs/kubectx/latest/completion"
  local src="${dir}/_${cmd}.zsh"

  if [[ ! -f "$src" ]]; then return; fi

  setup-completions "$cmd" "$src" cat "$src"
}

if command-exists kubectx; then
  _setup-kubectx-completion kubectx
fi

if command-exists kubens; then
  _setup-kubectx-completion kubens
fi

if command-exists helm; then
  setup-completions helm "$(command-path helm)" helm completion zsh
fi

if command-exists helmfile; then
  setup-completions helmfile "$(command-path helmfile)" helmfile completion zsh
fi
