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
# Helpers
# ==============================================================================

command-exists() {
  command -v "$1" &> /dev/null
  return $?
}

# ==============================================================================
# Zinit
# ==============================================================================

declare -A ZINIT
ZINIT[HOME_DIR]="$HOME/.local/zsh/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/bin"

# Ask to clone Zinit if it's not already available on disk.
[ ! -d "${ZINIT[BIN_DIR]}" ] && \
  read -q "REPLY?Zinit not installed, clone to ${ZINIT[BIN_DIR]}? [y/N]:" && \
  echo && git clone "https://github.com/zdharma/zinit.git" "${ZINIT[BIN_DIR]}"

# Load Zinit
source "${ZINIT[BIN_DIR]}/zinit.zsh"

# Enable using oh-my-zsh compatible themes.
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git
zinit cdclear -q # forget completions provided up to this point

# Enable interactive selection of completions.
zinit snippet OMZ::lib/completion.zsh

# Set various sane defaults for ZSH history management.
zinit snippet OMZ::lib/history.zsh

# Enable Ruby Bundler plugin from oh-my-zsh.
zinit snippet OMZ::plugins/bundler

zinit ice pick'plain.zsh-theme'
zinit light jimeh/plain.zsh-theme

zinit ice wait lucid
zinit light jimeh/zsh-peco-history

zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma/fast-syntax-highlighting

zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions

zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions


# ==============================================================================
# Private Dotfiles
# ==============================================================================

if [ -f "$DOTPFILES/zshrc" ]; then
  source "$DOTPFILES/zshrc"
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
source "$DOTZSH/emacs.zsh"
source "$DOTZSH/git.zsh"
source "$DOTZSH/less.zsh"
source "$DOTZSH/tmux.zsh"

# Development
source "$DOTZSH/docker.zsh"
source "$DOTZSH/golang.zsh"
source "$DOTZSH/google-cloud.zsh"
source "$DOTZSH/kubernetes.zsh"
source "$DOTZSH/nodejs.zsh"
source "$DOTZSH/python.zsh"
source "$DOTZSH/ruby.zsh"
source "$DOTZSH/rust.zsh"


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
