#
# Node.js environment setup.
#

# ==============================================================================
# global node packages
# ==============================================================================

install_node_global_packages() {
  local npm_packages=(
  )

  npm install -g "${npm_packages[@]}"

  # Ensure yarn and pnpm are enabled.
  corepack enable
}
