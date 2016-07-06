#
# Go (golang) environment setup.
#

export GOPATH="$HOME/.go:$HOME/Projects/Go"
path_prepend "$HOME/Projects/Go/bin:$HOME/.go/bin"

install_go_global_packages () {
  local packages=(
    github.com/golang/lint/golint \
    github.com/kisielk/errcheck \
    github.com/kr/pretty \
    github.com/laher/goxc \
    github.com/mdempsky/unconvert \
    github.com/motemen/gore \
    github.com/nsf/gocode \
    github.com/pmezard/go-difflib/difflib \
    github.com/rogpeppe/godef \
    github.com/tools/godep \
    golang.org/x/tools/cmd/goimports \
    launchpad.net/gorun \
  )

  for package in "${packages[@]}"; do
    echo "installing/updating \"$package\""
    go get -u "$package"
  done
}
