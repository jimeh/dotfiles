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
  setup-completions rustup "$(command-path rustup)" rustup completions zsh
fi

if command-exists cargo; then
  setup-completions cargo "$(command-path cargo)" rustup completions zsh cargo
fi
