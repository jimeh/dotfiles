#
# Go (golang) environment setup.
#

# ==============================================================================
# goenv
# ==============================================================================

# install goenv
zinit ice wait lucid as'program' pick'bin/goenv' from'gh' \
  atclone'src/configure && make -C src' atpull'%atclone' nocompile'!'
zinit light syndbg/goenv

zinit ice wait lucid as'program' pick'plugins/go-build/bin/go-build' from'gh' \
  id-as'syndbg/go-build'
zinit light syndbg/goenv

# lazy-load goenv
goenv() {
  load-goenv
  goenv "$@"
}

_goenv() {
  load-goenv
  _goenv "$@"
}

compctl -K _goenv goenv

load-goenv() {
  unset -f load-goenv _goenv goenv
  eval "$(command goenv init -)"
}

# ==============================================================================
# global golang packages
# ==============================================================================

install_go_global_packages() {
  local packages=(
    github.com/akavel/up
    github.com/asciimoo/wuzz
    github.com/cweill/gotests/...
    github.com/go-delve/delve/cmd/dlv
    github.com/golang/mock/gomock
    github.com/golang/mock/mockgen
    github.com/kisielk/errcheck
    github.com/mdempsky/unconvert
    github.com/rogpeppe/godef
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/guru
    golang.org/x/tools/gopls
  )

  for package in "${packages[@]}"; do
    echo "installing/updating \"$package\""
    go get -u "$package"
  done

  if command-exists goenv && [ "$(goenv version-name)" != "system" ]; then
    echo "running: goenv rehash..."
    goenv rehash
  fi
}
