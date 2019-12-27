#
# Rust environment setup.
#

# Rustup
if [ -d "$HOME/.cargo/bin" ]; then
  path_prepend "$HOME/.cargo/bin"
fi

install_rust_global_packages() {
  local packages=(
    rls
    rust-analysis
    rust-src
    rustfmt
  )

  rustup component add "${packages[@]}"
}
