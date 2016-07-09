#
# Go (golang) environment setup.
#

export GOPATH="$HOME/.go:$HOME/Projects/Go"
path_prepend "$HOME/Projects/Go/bin:$HOME/.go/bin"

install_go_global_packages () {
  local packages=( \
    github.com/FiloSottile/gvt \
    github.com/Masterminds/glide \
    github.com/alecthomas/gometalinter \
    github.com/golang/lint/golint \
    github.com/kardianos/govendor \
    github.com/kisielk/errcheck \
    github.com/kr/pretty \
    github.com/laher/goxc \
    github.com/mdempsky/unconvert \
    github.com/motemen/gore \
    github.com/nsf/gocode \
    github.com/pmezard/go-difflib/difflib \
    github.com/rakyll/boom \
    github.com/rogpeppe/godef \
    github.com/tools/godep \
    github.com/vektra/mockery/.../ \
    golang.org/x/tools/cmd/goimports \
    launchpad.net/gorun \
  )

  for package in "${packages[@]}"; do
    echo "installing/updating \"$package\""
    go get -u "$package"
  done
}
