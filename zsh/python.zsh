#
# Python environment setup.
#

# ==============================================================================
# aliases
# ==============================================================================

alias ap="env OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-playbook"
alias av="env OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-vault"
alias mo="env OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES molecule"

# ==============================================================================
# global python package
# ==============================================================================

install_python_global_packages() {
  local packages=(
    'ansible'
    'grip'
    'molecule[docker]'
    'passlib'
    'yamllint'
  )

  local pipcmd="pip"
  if command-exists pip3; then pipcmd="pip3"; fi

  "$pipcmd" install --upgrade setuptools
  "$pipcmd" install --upgrade "${packages[@]}"
}
