#
# Go (golang) environment setup.
#

# ==============================================================================
# global golang packages
# ==============================================================================

list_go_global_packages() {
  local bindir="${GOBIN:-$(go env GOBIN)}"
  if [ -z "$bindir" ]; then
    echo "GOBIN is not set"
    return 1
  fi

  for cmd in $(ls -1 "${GOBIN}"); do
    go version -m "${GOBIN}/${cmd}" | grep '^[[:space:]]path' | awk '{ print $2 }'
  done
}

install_go_global_packages() {
  local packages=()

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
