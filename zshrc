#
# Z-Shell Init
#

# In our zshenv file we have on macOS disabled loading ZSH startup files from
# /etc to avoid /etc/zprofile messing up our carefully constructed PATH. So we
# need to manually load the other files we care about.
if [[ "$OSTYPE" == "darwin"* ]] && [ -f "/etc/zshrc" ]; then
  source "/etc/zshrc"
fi

# ==============================================================================
# Zinit
# ==============================================================================

declare -A ZINIT
ZINIT[HOME_DIR]="$HOME/.local/zsh/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/bin"

# Load zinit module if it exists. For more info, run: zinit module help
if [ -d "${ZINIT[HOME_DIR]}/module/Src/zdharma_continuum" ]; then
  module_path+=("${ZINIT[HOME_DIR]}/module/Src")
  zmodload zdharma_continuum/zinit
fi

# Ask to clone Zinit if it's not already available on disk.
[ ! -d "${ZINIT[BIN_DIR]}" ] &&
  read -q "REPLY?Zinit not installed, clone to ${ZINIT[BIN_DIR]}? [y/N]:" &&
  echo &&
  git clone --depth=1 "https://github.com/zdharma-continuum/zinit.git" "${ZINIT[BIN_DIR]}"

# Load Zinit
source "${ZINIT[BIN_DIR]}/zinit.zsh"

# Enable interactive selection of completions.
zinit for @OMZ::lib/completion.zsh

# Set various sane defaults for ZSH history management.
zinit for @OMZ::lib/history.zsh

# Enable Ruby Bundler plugin from oh-my-zsh.
zinit for @OMZ::plugins/bundler

zinit light-mode wait lucid \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  for @zdharma-continuum/fast-syntax-highlighting

zinit light-mode wait lucid blockf \
  for @zsh-users/zsh-completions

zinit light-mode wait lucid atload"!_zsh_autosuggest_start" \
  for @zsh-users/zsh-autosuggestions

# ==============================================================================
# Completion
# ==============================================================================

# Group completions by type under group headings
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# Improve selection of Makefile completions - from:
# https://github.com/zsh-users/zsh-completions/issues/541#issuecomment-384223016
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:make:*' tag-order targets

if [ -d "$ZSH_COMPLETIONS" ]; then fpath=("$ZSH_COMPLETIONS" $fpath); fi
if [ -d "$DOTZSH_SITEFUNS" ]; then fpath=("$DOTZSH_SITEFUNS" $fpath); fi

# setup-completions is a helper function to setup completions for a given
# command. It takes the command name, the source of the completion, and the
# command to run to generate the completions.
#
# Source should be a file that the completions are generated from. For example,
# for rustup, the source is the rustup binary. If completions file has already
# been generated, the source file is used to determine if the completions need
# to be re-generated.
#
# The command to run to generate the completions should be a command that
# generates zsh completions. For example, for rustup, the command is:
#
#     rustup completions zsh
#
# Example usage:
#
#     setup-completions rustup "$(command -v rustup)" rustup completions zsh
#
# This will generate the completions for rustup and place them in the
# ZSH_COMPLETIONS directory.
setup-completions() {
  local cmd="$1"
  local source="$2"
  shift 2
  local target
  target="${ZSH_COMPLETIONS}/_${cmd}"

  if [ ! -f "$target" ] || [ "$target" -ot "$source" ]; then
    echo "Setting up completion for $cmd -- $target"
    mkdir -p "$(dirname "$target")"
    "$@" > "$target"
    chmod +x "$target"
    autoload -U compinit && compinit
  fi
}

# ==============================================================================
# Edit command line
# ==============================================================================

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# ==============================================================================
# Private Dotfiles
# ==============================================================================

if [ -f "$DOTPFILES/zshrc" ]; then
  source "$DOTPFILES/zshrc"
fi

# ==============================================================================
# Environment and Tool Managers
# ==============================================================================

# If available, make sure to load direnv shell hook before mise.
if command-exists direnv; then
  eval "$(direnv hook zsh)"
fi

MISE_HOME="$HOME/.local/share/mise"
MISE_ZSH_INIT="$MISE_HOME/shell/init.zsh"
export MISE_INSTALL_PATH="$MISE_HOME/bin/mise"

if ! command-exists mise; then
  read -q 'REPLY?mise is not installed, install with `curl https://mise.jdx.dev/install.sh | sh`? [y/N]:' &&
    echo && curl https://mise.jdx.dev/install.sh | sh
fi

if command-exists mise; then
  alias mi="mise"

  if [ ! -f "$MISE_ZSH_INIT" ] || [ "$MISE_ZSH_INIT" -ot "$MISE_INSTALL_PATH" ]; then
    mkdir -p "$(dirname "$MISE_ZSH_INIT")"
    mise activate zsh > "$MISE_ZSH_INIT"
  fi
  source "$MISE_ZSH_INIT"

  setup-completions mise "$MISE_INSTALL_PATH" mise completions zsh
fi

# ==============================================================================
# Prompt
# ==============================================================================

if ! command-exists starship; then
  read -q 'REPLY?starship is not installed, install with `mise install starship`? [y/N]:' &&
    echo && mise install starship
fi

if command-exists starship; then
  eval "$(starship init zsh --print-full-init)"

  _starship() {
    unset -f _starship
    eval "$(starship completions zsh)"
  }
  compctl -K _starship starship
else
  echo "WARN: starship not found, skipping prompt setup" >&2
  echo "      install with: mise install starship" >&2

fi

# ==============================================================================
# Tool specific setup
# ==============================================================================

# Aliases
source "$DOTZSH/aliases.zsh"

# OS specific
if [[ "$OSTYPE" == "darwin"* ]]; then source "$DOTZSH/macos.zsh"; fi
if [[ "$OSTYPE" == "linux"* ]]; then source "$DOTZSH/linux.zsh"; fi

# Utils
source "$DOTZSH/1password.zsh"
source "$DOTZSH/copilot.zsh"
source "$DOTZSH/emacs.zsh"
source "$DOTZSH/fzf.zsh"
source "$DOTZSH/less.zsh"
source "$DOTZSH/neovim.zsh"
source "$DOTZSH/nix.zsh"
source "$DOTZSH/tmux.zsh"
source "$DOTZSH/zoxide.zsh"

# Development
source "$DOTZSH/containers.zsh"
source "$DOTZSH/git.zsh"
source "$DOTZSH/golang.zsh"
source "$DOTZSH/google-cloud.zsh"
source "$DOTZSH/kubernetes.zsh"
source "$DOTZSH/nodejs.zsh"
source "$DOTZSH/python.zsh"
source "$DOTZSH/ruby.zsh"
source "$DOTZSH/rust.zsh"
source "$DOTZSH/scaleway.zsh"

# ==============================================================================
# Basic Z-Shell settings
# ==============================================================================

# Disable auto-title.
DISABLE_AUTO_TITLE="true"

# Disable shared history.
unsetopt share_history

# Disable attempted correction of commands (is wrong 98% of the time).
unsetopt correctall

# ==============================================================================
# Local Overrides
# ==============================================================================

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

autoload -U +X bashcompinit && bashcompinit
