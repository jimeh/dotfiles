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
