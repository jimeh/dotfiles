#
# Kubernetes Related
#

alias kc="kubectl"
alias kx="kubectx"
alias kn="kubens"
alias hl="helm"
alias mk="minikube"

if command-exists kubectl; then
  setup-completions kubectl "$(command -v kubectl)" kubectl completion zsh

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
  local target="$ZSH_COMPLETIONS/_${cmd}"

  if [[ -f "$target" || ! -d "$dir" ]]; then
    return
  fi

  echo "Setting up completion for $cmd -- $target"

  local script
  if [ -f "${dir}/${cmd}.zsh" ]; then
    script="$dir/${cmd}.zsh"
  elif [ -f "${dir}/_${cmd}.zsh" ]; then
    script="$dir/_${cmd}.zsh"
  fi

  echo "  - Sym-linking from $script"
  mkdir -p "$ZSH_COMPLETIONS"
  ln -s "$script" "$target"

  if ! (whence -w compinit &> /dev/null); then
    autoload -U compinit && compinit
  fi
}

if command-exists kubectx; then
  _setup-kubectx-completion kubectx
fi

if command-exists kubens; then
  _setup-kubectx-completion kubens
fi
