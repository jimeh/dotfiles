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

# Download completion scripts for kubectx and kubens from their git repo at
# their respective versions. This is required as neither command has an option
# to output their completion scripts, unlike most tools.
_setup-kubectx-completion() {
  local cmd="$1"
  local version
  local src_url
  local tmpfile

  # If the command already has completions, don't do anything.
  if whence -w "_${cmd}" > /dev/null; then return; fi

  tmpfile="$(mktemp -d)/_${cmd}.zsh"
  version="$(printf '%s' "$(command "$cmd" --version 2> /dev/null)")"
  version="${version#v}"
  src_url="https://github.com/ahmetb/kubectx/raw/refs/tags/v${version}/completion/_${cmd}.zsh"

  echo "Completion script for ${cmd} (v${version}) not found. Download and install?"
  echo
  echo "  Download from: ${src_url}"
  echo "        Save to: ${tmpfile}"
  echo
  read -q "REPLY?Continue? [y/N]:" || return
  echo
  echo

  curl -L "$src_url" -o "${tmpfile}" &&
    echo &&
    setup-completions "$cmd" "$(command-path "$cmd")" cat "$tmpfile"
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
