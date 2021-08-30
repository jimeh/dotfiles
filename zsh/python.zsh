#
# Python environment setup.
#

# ==============================================================================
# pyenv
# ==============================================================================

# install pyenv
zinit ice wait lucid as'program' pick'bin/pyenv' from'gh' \
  atclone'src/configure && make -C src; libexec/pyenv init - > .zinitrc.zsh' \
  atpull'%atclone' src'.zinitrc.zsh' nocompile'!'
zinit light pyenv/pyenv

zinit ice wait lucid as'program' pick'plugins/python-build/bin/python-build' \
  from'gh' id-as'pyenv/python-build'
zinit light pyenv/pyenv

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
