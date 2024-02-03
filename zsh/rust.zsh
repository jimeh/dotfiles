#
# Rust environment setup.
#

# ==============================================================================
# aliases
# ==============================================================================

alias c="cargo"

if command-exists exa; then
  alias ll="exa -lagHS --color-scale --icons --git"
  alias llt="ll --tree"
fi

if command-exists bat; then
  alias cat="bat -P"
fi

# ==============================================================================
# completions
# ==============================================================================

if command-exists rustup; then
  _rustup() {
    unset -f _rustup
    eval "$(rustup completions zsh)"
  }
  compctl -K _rustup rustup

  if command-exists cargo; then
    _cargo() {
      unset -f _cargo
      eval "$(rustup completions zsh cargo)"
    }
    compctl -K _cargo cargo
  fi
fi

# ==============================================================================
# global rust packages
# ==============================================================================

install_rust_global_packages() {
  (
    set -e

    if ! command-exists rustup; then
      read -q "REPLY?Rustup was not found. Install it? [y/N] " &&
        echo &&
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi

    if ! command-exists rustup; then
      echo "Rustup was not found. Aborting."
      return 1
    fi

    rustup component add \
      clippy \
      rust-analyzer \
      rust-src \
      rustfmt

    # Install or update cargo-binstall
    if ! command-exists cargo-binstall; then
      RUSTC_WRAPPER="${commands[sccache]}" cargo install cargo-binstall
    fi

    # Install sccache before the rest of the packages.
    if ! command-exists sccache; then
      RUSTC_WRAPPER="" cargo binstall sccache
    fi

    RUSTC_WRAPPER=sccache cargo binstall cargo-quickinstall

    RUSTC_WRAPPER=sccache cargo quickinstall \
      cargo-audit \
      cargo-info

    RUSTC_WRAPPER=sccache cargo binstall -y \
      bacon \
      bat \
      cargo-edit \
      cargo-update \
      difftastic \
      dirstat-rs \
      exa \
      hexyl \
      jwt-cli
  )
}
