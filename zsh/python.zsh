#
# Python environment setup
#

install_python_global_packages () {
  local packages=(
    'ansible'
    'molecule[docker]'
  )

  if (( $+commands[brew] )); then
    brew list python >/dev/null || brew install python
  fi

  local pipcmd="pip"
  if (( $+commands[pip3] )); then; pipcmd="pip3"; fi

  $pipcmd install --upgrade setuptools
  $pipcmd install --upgrade "${packages[@]}"
}

# Aliases
alias ap="ansible-playbook"
alias av="ansible-vault"
alias mo="molecule"
