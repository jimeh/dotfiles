#
# Rust environment setup.
#

# ==============================================================================
# aliases
# ==============================================================================

alias c="cargo"

if command-exists eza; then
  alias ll="eza -lagHS --icons --git"
  alias llt="ll --tree"
fi

if command-exists bat; then
  alias cat="bat -P"
fi

# ==============================================================================
# completions
# ==============================================================================

if command-exists rustup; then
  setup-completions rustup "$(command -v rustup)" rustup completions zsh

  if command-exists cargo; then
    setup-completions cargo "$(command -v cargo)" rustup completions zsh cargo
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
  )
}
