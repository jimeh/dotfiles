#
# Python environment setup
#

install_python_global_packages() {
  local packages=(
    'ansible'
    'grip'
    'molecule[docker]'
    'yamllint'
  )

  local pipcmd="pip"
  if command-exists pip3; then pipcmd="pip3"; fi

  "$pipcmd" install --upgrade setuptools
  "$pipcmd" install --upgrade "${packages[@]}"
}

# Aliases
alias ap="env OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-playbook"
alias av="env OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-vault"
alias mo="env OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES molecule"

if command-exists pyenv; then
  # lazy-load pyenv
  pyenv() {
    load-pyenv
    pyenv "$@"
  }

  _pyenv() {
    load-pyenv
    _pyenv "$@"
  }

  compctl -K _pyenv pyenv

  load-pyenv() {
    unset -f load-pyenv _pyenv pyenv
    eval "$(command pyenv init -)"
  }
fi
