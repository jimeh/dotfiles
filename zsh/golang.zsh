#
# Go (golang) environment setup.
#

# ==============================================================================
# global golang packages
# ==============================================================================

list_go_global_packages() {
  for bin in $(ls -1 ~/.go/bin); do
    go version -m ~/.go/bin/$bin | grep '^[[:space:]]path' | awk '{ print $2 }'
  done
}

install_go_global_packages() {
  local packages=(
    github.com/akavel/up@latest
    github.com/asciimoo/wuzz@latest
    github.com/bufbuild/buf-language-server/cmd/bufls@latest
    github.com/caddyserver/xcaddy/cmd/xcaddy@latest
    github.com/erning/gorun@latest
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/golang/mock/mockgen@latest
    github.com/icholy/gomajor@latest
    github.com/kisielk/errcheck@latest
    github.com/mdempsky/unconvert@latest
    github.com/nametake/golangci-lint-langserver@latest
    github.com/ramya-rao-a/go-outline@latest
    github.com/rogpeppe/godef@latest
    github.com/segmentio/golines@latest
    github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
    golang.org/x/tools/cmd/godoc@latest
    golang.org/x/tools/cmd/goimports@latest
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
