#
# Go (golang) environment setup.
#

export GOPATH="$HOME/.go:$HOME/Projects/Go"
path_prepend "$HOME/.go/bin"
path_prepend "$HOME/Projects/Go/bin"

# aliases
alias gv="govendor"

install_go_global_packages () {
  local packages=(
    github.com/akavel/up
    github.com/alecthomas/gometalinter
    github.com/asciimoo/wuzz
    github.com/derekparker/delve/cmd/dlv
    github.com/golang/lint/golint
    github.com/kisielk/errcheck
    github.com/kr/pretty
    github.com/mdempsky/unconvert
    github.com/nsf/gocode
    github.com/rakyll/hey
    github.com/rogpeppe/godef
    github.com/spf13/cobra/cobra
    github.com/vektra/mockery/.../
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/gorename
    golang.org/x/tools/cmd/guru
  )

  for package in "${packages[@]}"; do
    echo "installing/updating \"$package\""
    go get -u "$package"
  done

  gometalinter --install
}
