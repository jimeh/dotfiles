#
# Rust environment setup.
#

# Rustup
if [ -d "$HOME/.cargo/bin" ]; then
  path_prepend "$HOME/.cargo/bin"
fi

install_rust_global_packages() {
  rustup component add rustfmt-preview
  rustup component add rust-src
  cargo +nightly install --force clippy
  cargo install --force racer
}
