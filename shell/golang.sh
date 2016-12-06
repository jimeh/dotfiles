#
# Go (golang) environment setup.
#

export MYGOPATH="$HOME/Projects/Go"

# load gvm
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# setup GOPATH after loading gvm
export GOPATH="$GOPATH:$MYGOPATH"
path_prepend "$MYGOPATH/bin"

# aliases
alias gv="govendor"
gvm-use() {
  gvm use $@
  export GOPATH="$GOPATH:$MYGOPATH"
}

install_go_global_packages () {
  local packages=( \
    github.com/FiloSottile/gvt \
    github.com/Masterminds/glide \
    github.com/alecthomas/gometalinter \
    github.com/golang/lint/golint \
    github.com/kardianos/govendor \
    github.com/kisielk/errcheck \
    github.com/kovetskiy/manul \
    github.com/kr/pretty \
    github.com/laher/goxc \
    github.com/mailgun/godebug \
    github.com/mdempsky/unconvert \
    github.com/mitchellh/gox \
    github.com/motemen/gore \
    github.com/nsf/gocode \
    github.com/pmezard/go-difflib/difflib \
    github.com/rakyll/boom \
    github.com/rogpeppe/godef \
    github.com/tools/godep \
    github.com/vektra/mockery/.../ \
    golang.org/x/tools/cmd/goimports \
    golang.org/x/tools/cmd/gorename \
    golang.org/x/tools/cmd/guru \
  )

  for package in "${packages[@]}"; do
    echo "installing/updating \"$package\""
    go get -u "$package"
  done

  gometalinter --install
}
