#
# Go (golang) environment setup.
#

#
# g - Simple go version manager, gluten-free
#

# Create symlink for "g" called "gv", as I have "g" aliased to "git".
zinit light-mode wait lucid as'program' pick'bin/g' from'gh' \
  atclone'cd bin && ln -s g gv' atpull'%atclone' \
  for @stefanmaric/g

#
# gup - Update binaries installed with "go install"
#
zinit light-mode wait lucid as'program' from'gh-r' pick'gup' \
  for @nao1215/gup

#
# global golang packages
#

list_go_global_packages() {
  for bin in $(ls -1 ~/.go/bin); do
    go version -m ~/.go/bin/$bin | grep '^[[:space:]]path' | awk '{ print $2 }'
  done
}

install_go_global_packages() {
  local packages=(
    github.com/akavel/up@latest
    github.com/asciimoo/wuzz@latest
    github.com/cweill/gotests/...@latest
    github.com/cweill/gotests/gotests@latest
    github.com/erning/gorun@latest
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/golang/mock/mockgen@latest
    github.com/google/go-jsonnet/cmd/jsonnet@latest
    github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
    github.com/icholy/gomajor@latest
    github.com/kisielk/errcheck@latest
    github.com/lighttiger2505/sqls@latest
    github.com/mdempsky/unconvert@latest
    github.com/nametake/golangci-lint-langserver@latest
    github.com/ramya-rao-a/go-outline@latest
    github.com/rogpeppe/godef@latest
    github.com/segmentio/golines@latest
    github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
    golang.org/x/lint/golint@latest
    golang.org/x/tools/cmd/godoc@latest
    golang.org/x/tools/cmd/goimports@latest
    golang.org/x/tools/cmd/guru@latest
    golang.org/x/tools/cmd/stringer@latest
    golang.org/x/tools/gopls@latest
    google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
    google.golang.org/protobuf/cmd/protoc-gen-go@latest
    mvdan.cc/gofumpt@latest
  )

  for package in "${packages[@]}"; do
    echo "installing/updating \"$package\""
    if [[ "$package" == *"@"* ]]; then
      GO111MODULE=on go install "$package"
    else
      GO111MODULE=on go get -u "$package"
    fi
  done

  if command-exists goenv && [ "$(goenv version-name)" != "system" ]; then
    echo "running: goenv rehash..."
    goenv rehash
  fi
}
