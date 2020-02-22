#
# Rust environment setup.
#

install_rust_global_packages() {
  local packages=(
    rls
    rust-analysis
    rust-src
    rustfmt
  )

  rustup component add "${packages[@]}"
}
