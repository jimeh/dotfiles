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
  (( ${+commands[$1]} ))
  return $?
}

# ==============================================================================
# Zinit
# ==============================================================================

declare -A ZINIT
ZINIT[HOME_DIR]="$HOME/.local/zsh/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/bin"

# Load zinit module if it exists. For more info, run: zinit module help
if [ -d "${ZINIT[BIN_DIR]}/zmodules/Src/zdharma" ]; then
  module_path+=("${ZINIT[BIN_DIR]}/zmodules/Src")
  zmodload zdharma/zplugin
fi

# Ask to clone Zinit if it's not already available on disk.
[ ! -d "${ZINIT[BIN_DIR]}" ] &&
  read -q "REPLY?Zinit not installed, clone to ${ZINIT[BIN_DIR]}? [y/N]:" &&
  echo &&
  git clone --depth=1 "https://github.com/zdharma/zinit.git" "${ZINIT[BIN_DIR]}"

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


zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma/fast-syntax-highlighting

zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions

zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

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
# Tool specific setup
# ==============================================================================

# Aliases
source "$DOTZSH/aliases.zsh"

# OS specific
if [[ "$OSTYPE" == "darwin"* ]]; then source "$DOTZSH/macos.zsh"; fi
if [[ "$OSTYPE" == "linux"* ]]; then source "$DOTZSH/linux.zsh"; fi

# Utils
source "$DOTZSH/emacs.zsh"
source "$DOTZSH/fzf.zsh"
source "$DOTZSH/git.zsh"
source "$DOTZSH/less.zsh"
source "$DOTZSH/rclone.zsh"
source "$DOTZSH/tmux.zsh"

# Development
source "$DOTZSH/direnv.zsh"
source "$DOTZSH/docker.zsh"
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

if [ -d "$DOTZSH/site-functions" ]; then
  fpath=("$DOTZSH/site-functions" $fpath)
fi

autoload -U +X bashcompinit && bashcompinit
