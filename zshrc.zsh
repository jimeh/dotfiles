#
# Z-Shell Init
#

if [ -n "$0" ] && [ -f "$0" ]; then
  DOTFILES="`dirname \"$0\"`"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES="$HOME/.dotfiles"
fi

# ==============================================================================
# Environment variables
# ==============================================================================

# Export path variables.
DOTPFILES="$DOTFILES/private"
DOTBIN="$DOTFILES/bin"
DOTZSH="$DOTFILES/zsh"

# Path helpers.
source "$DOTZSH/path_helpers.zsh"

# Ensure /usr/local/bin is before various system-paths
path_prepend "/usr/local/bin"

# Editors
export EDITOR="emacsclient-wrapper"
export GEM_EDITOR="mate"

# Locale Setup
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# ensure bin and sbin paths from /usr/local are in PATH
path_add_after "/usr/local/sbin" "/usr/local/bin"

# ensure bin and sbin paths from /usr are in PATH
path_add_after "/usr/sbin" "/usr/bin"

# Add user's bin directory to PATH
path_prepend "$HOME/bin"

# Add dotfiles' bin directory to PATH
path_prepend "$DOTBIN"

# Ensure TMPDIR is the same for local and remote ssh logins
if [[ $TMPDIR == "/var/folders/"* ]] || [[ $TMPDIR == "" ]]; then
  export TMPDIR="/tmp/user-$USER"
  mkdir -p "$TMPDIR"
fi

# ==============================================================================
# zplug
# ==============================================================================

ZPLUG_HOME="$DOTZSH/zplug/zplug"
ZPLUG_CACHE_DIR="$DOTZSH/zplug/cache"
ZPLUG_REPOS="$DOTZSH/zplug/repos"

source "$ZPLUG_HOME/init.zsh"
alias zp="zplug"

zplug "lib/history", from:oh-my-zsh, defer:1
zplug "jimeh/zsh-peco-history", defer:2
zplug "plugins/bundler", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

zplug "jimeh/plain.zsh-theme", as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo
    zplug install
  fi
fi

# Configure zsh-syntax-highlighting
if zplug check zsh-users/zsh-syntax-highlighting; then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi

zplug load

# ==============================================================================
# Completion
# ==============================================================================

# Enable bash-style completion.
autoload -Uz +X compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit

fpath=("$DOTZSH/completion" "${fpath[@]}")

# ==============================================================================
# Load custom scripts
# ==============================================================================

# Aliases
source "$DOTZSH/aliases.zsh"

# OS specific
source "$DOTZSH/osx.zsh"
source "$DOTZSH/linux.zsh"

# Utils
source "$DOTZSH/emacs.zsh"
source "$DOTZSH/git.zsh"
source "$DOTZSH/tmux.zsh"
source "$DOTZSH/less.zsh"

# Development
source "$DOTZSH/nodejs.zsh"
source "$DOTZSH/ruby.zsh"
source "$DOTZSH/rust.zsh"
source "$DOTZSH/golang.zsh"
source "$DOTZSH/docker.zsh"
source "$DOTZSH/google-cloud.zsh"
source "$DOTZSH/kubernetes.zsh"

if [ -f "$DOTPFILES/shellrc.sh" ]; then
  source "$DOTPFILES/shellrc.sh"
fi

# ==============================================================================
# Basic Z-Shell settings
# ==============================================================================

# Disable auto-title.
DISABLE_AUTO_TITLE="true"

# Disable shared history.
unsetopt share_history

# Disable attempted correction of commands (is wrong 98% of the time).
unsetopt correctall
