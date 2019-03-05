#
# Rust environment setup.
#

# Rustup
if [ -d "$HOME/.cargo/bin" ]; then
  path_prepend "$HOME/.cargo/bin"
fi

install_rust_global_packages() {
  rustup component add \
         rls \
         rust-analysis \
         rust-src \
         rustfmt \
}
