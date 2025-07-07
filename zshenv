#
# ZSH Environment Setup
#

# Enable ZSH profiling?
if [[ -n "$ZPROF" ]]; then
  zmodload zsh/zprof
fi

# Ensure compinit is NOT loaded before Zinit loads in `~/zshrc`.
skip_global_compinit=1

# ==============================================================================
# PATH Setup
# ==============================================================================

# Ensure values in `path` variable are unique.
typeset -U path

# Prevent loading ZSH start-up from files `/etc` on macOS. The `/etc/zprofile`
# file screws around with `PATH`, so we want to avoid it, and instead manually
# load the files we care about.
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Disable loading start-up files from `/etc`.
  unsetopt GLOBAL_RCS

  # Setup default `PATH` just like `/etc/zprofile` does.
  if [ -x "/usr/libexec/path_helper" ]; then
    eval $(/usr/libexec/path_helper -s)
  fi

  # Load `/etc/zshenv` if it exists.
  if [ -f "/etc/zshenv" ]; then
    source "/etc/zshenv"
  fi
fi

# ==============================================================================
# PATH Helpers
# ==============================================================================

path_list () {
  print -l "${(@)path}"
}

path_remove () {
  path=("${(@)path:#$1}")
}

path_append () {
  if [ -d "$1" ]; then
    path+="$1"
  fi
}

path_prepend () {
  if [ -d "$1" ]; then
    path=("$1" "${(@)path:#$1}")
  fi
}

# ==============================================================================
# Helpers
# ==============================================================================

command-exists() {
  (( ${+commands[$1]} ))
  return $?
}

command-path() {
  if ! command-exists "$1"; then
    return 1
  fi

  echo "${commands[$1]}"
}

# mise-which is a wrapper around the `mise which` command. If mise is not
# available, or `mise which` fails to find the command, it falls back to the
# `command-path` function.
#
# Primarily used before mise is initialized in an interactive shell, where
# regular path lookup would return the shimmed version of the command, but you
# actually need the absolute path to the command.
#
# Arguments:
#   $1 - cmd: The command to find the path to.
mise-which() {
  command-exists mise && mise which "$1" 2>/dev/null || command-path "$1"
}

source-if-exists() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

# mtime returns the modification time of a file in seconds since epoch.
#
# Supports macOS and Linux.
#
# Arguments:
#
#   $1 - file: The path to the file to get the modification time of.
#
# Returns:
#   The modification time of the file in seconds since epoch.
mtime() {
  local file="$1"

  if [ -f "$file" ]; then
    case "$(uname)" in
      Darwin)
        stat -f "%m" "$file"
        ;;
      Linux)
        stat -c "%Y" "$file"
        ;;
    esac
  fi
}

# cached-eval executes a command with arguments and caches the output. On
# subsequent calls, if the source file has not changed, the output is sourced
# from the cache instead of re-executing the command. This optimizes performance
# for commands that are costly to execute but result in the same output unless
# their source files change.
#
# The cache key is calculated from the source file path, its modification time,
# and the command to execute. If any of those change, the command is re-executed
# and the cache is updated to a new cache file.
#
# Arguments:
#
#   $1 - source_file: The path to the source file that the command depends on.
#                     If this file is newer than the cache, the command is
#                     re-executed and the cache is updated.
#   $@ - script:      The command to execute and cache the output of.
#
# Example usage:
#
#     cached-eval "$(command -v direnv)" direnv hook zsh
#     cached-eval "$(command -v mise)" mise activate zsh
#
# The above commands will cache the output of `direnv hook zsh` and `mise
# activate zsh` respectively. If the source file is newer than the cache, the
# command is re-executed and cache is updated.
cached-eval() {
  local source_file="$1"
  shift 1
  local script="$@"

  # If given source file is empty, silently return 0. This allows us to call
  # cached-eval with dynamic command path lookup, without having to wrap it in a
  # if statement that checks if the command exists.
  if [[ -z "$source_file" ]]; then
    return 0
  fi

  if [[ -z "$script" ]]; then
    echo "cached-eval: No script provided for: $source_file" >&2
    return 1
  fi

  if [[ ! -f "$source_file" ]]; then
    echo "cached-eval: Source file not found: $source_file" >&2
    return 1
  fi

  local cache_dir="${ZSH_CACHED_EVAL_DIR:-$HOME/.local/share/zsh/cached-eval}"
  local hash_cmd="$(command-path shasum || command-path sha1sum)"
  local mtime="$(mtime "$source_file")"
  local cache_hash="$(echo -n "${source_file}:${mtime}:${script}" | \
    "$hash_cmd" | awk '{print $1}')"
  local cache_file="${cache_dir}/${cache_hash}.cache.zsh"

  if [ -z "$cache_hash" ]; then
    echo "cached-eval: Failed to compute cache hash for: $script" >&2
    return 1
  fi

  if [[ ! -f "$cache_file" || "$source_file" -nt "$cache_file" ]]; then
    mkdir -p "$cache_dir"
    echo "cached-eval: Updating cache for: $script --> $cache_file" >&2
    echo -e "#\n# Generated by cached-eval: $script\n#\n" >| "$cache_file"
    eval "$script" >>| "$cache_file"
  fi

  source "$cache_file"
}

flush-cached-eval() {
  local cache_dir="${ZSH_CACHED_EVAL_DIR:-$HOME/.local/share/zsh/cached-eval}"

  if [[ ! -d "$cache_dir" ]]; then
    echo "cached-eval: Cache directory not found: $cache_dir" >&2
    return 1
  fi

  local cache_files=("$cache_dir"/*.cache.zsh)
  if [[ "${#cache_files[@]}" -eq 0 ]]; then
    echo "cached-eval: No cache files found in: $cache_dir" >&2
    return 1
  fi

  for cache_file in "${cache_files[@]}"; do
    echo "cached-eval: Flushing cache file: $cache_file" >&2
    rm -f "$cache_file"
  done
}

# ==============================================================================
# System Environment Setup
# ==============================================================================

DOTFILES="$HOME/.dotfiles"
DOTBIN="$DOTFILES/bin"
DOTZSH="$DOTFILES/zsh"

# Editors
export EDITOR="emacsclient-wrapper"
export GEM_EDITOR="mate"

# Locale Setup
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Ensure TMPDIR is the same for local and remote ssh logins
if [[ "$TMPDIR" == "/var/folders/"* ]] || [[ "$TMPDIR" == "" ]]; then
  export TMPDIR="/tmp/user-$USER"
  mkdir -p "$TMPDIR"
fi

export DOTZSH_SITEFUNS="$DOTZSH/site-functions"
export ZSH_COMPLETIONS="$HOME/.local/share/zsh/completions"
export ZSH_CACHED_EVAL_DIR="$HOME/.local/share/zsh/cached-eval"

# Ensure basic systems paths are in desired order
path_prepend "/bin"
path_prepend "/sbin"
path_prepend "/usr/bin"
path_prepend "/usr/sbin"
path_prepend "/usr/local/bin"
path_prepend "/usr/local/sbin"

# Add dotfiles' bin directory to PATH
path_prepend "$DOTBIN"

# Add user's bin directory to PATH
path_prepend "$HOME/bin"

# ==============================================================================
# Private Dotfiles Environment
# ==============================================================================

DOTPFILES="$DOTFILES/private"

if [ -f "$DOTPFILES/zshenv" ]; then
  source "$DOTPFILES/zshenv"
fi

# ==============================================================================
# Third-party Environment Setup
# ==============================================================================

# Homebrew on Apple Silicon
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if command-exists brew; then
  typeset -A _brew_prefix_cache

  brew-prefix() {
    local package="${1:-__none__}"

    if [[ -z "${_brew_prefix_cache[$package]}" ]]; then
      _brew_prefix_cache[$package]="$(brew --prefix "$1" || return $?)"
    fi

    echo "${_brew_prefix_cache[$package]}"
  }

  export BREW_SITEFUNS="$(brew-prefix)/share/zsh/site-functions"
fi

# Linuxbrew
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  # Inline linux-brew setup to improve shell startup speed by around 200 ms.
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}"
  export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH+:$INFOPATH}"
  path_prepend "${HOMEBREW_PREFIX}/bin"
  path_prepend "${HOMEBREW_PREFIX}/sbin"
fi

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  # export NIX_PATH="$HOME/.nix-defexpr"
fi

# Android SDK environment setup.
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path_append "$ANDROID_HOME/emulator"
  path_append "$ANDROID_HOME/tools"
  path_append "$ANDROID_HOME/tools/bin"
  path_append "$ANDROID_HOME/platform-tools"
fi

# Flutter environment setup.
path_append "/opt/flutter/bin"
path_append "/opt/flutter/bin/cache/dart-sdk/bin"

# Use gnu-getop if available.
path_prepend "/usr/local/opt/gnu-getopt/bin"

# Homebrew setup.
export HOMEBREW_NO_ANALYTICS=1

# Kubernetes setup
export KUBECONFIG="$HOME/.kube/config"
if [ -d "$HOME/.krew" ]; then
  export KREW_ROOT="$HOME/.krew"
  path_append "$HOME/.krew/bin"
fi

# Use custom Emacs installation if available.
path_prepend "/opt/emacs/bin"

# evm setup.
export EVM_MODE=user
export EVM_NATIVE_FULL_AOT=1
path_prepend "$HOME/.evm/shims"

# Set Emacs-related environment variables
export EMACS="emacs"
export EMACSCLIENT="emacsclient"
export LSP_USE_PLISTS="true" # Improve lsp-mode performance.

# On macOS we want to use the Emacs.app application bundle
if [[ "$OSTYPE" == "darwin"* ]]; then
  path_prepend "/Applications/Emacs.app/Contents/MacOS/bin"
  if [ ! -f "/Applications/Emacs.app/Contents/MacOS/bin/emacs" ] && \
    [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
    export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
  fi
fi

# Use custom tmux install if available
path_prepend "/opt/tmux/bin"

# Rust setup
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"
path_prepend "$CARGO_HOME/bin"

export RUST_BACKTRACE=1
if command-exists sccache; then
  export RUSTC_WRAPPER=sccache
else
  export RUSTC_WRAPPER=""
fi

# `~/.local/bin` used by some tools (mise, pipx, lunar, toml-sort, etc.)
path_prepend "$HOME/.local/bin"

# mise setup
export MISE_LIST_ALL_VERSIONS=0
path_prepend "$HOME/.local/share/mise/shims"

# aqua setup
path_prepend "$HOME/.local/share/aquaproj-aqua/bin"

# orbstack setup
source-if-exists "$HOME/.orbstack/shell/init.zsh"
path_prepend "$HOME/.orbstack/bin"

# Google Cloud SDK setup
source-if-exists "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

# Windsurf setup
path_prepend "$HOME/.codeium/windsurf/bin"

# ==============================================================================
# Local Overrides
# ==============================================================================

if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
