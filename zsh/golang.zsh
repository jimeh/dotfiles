#
# Go (golang) setup.
#

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
}
