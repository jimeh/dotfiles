#
# Z-Shell Init
#

# In our zshenv file we have on macOS disabled loading ZSH startup files from
# /etc to avoid /etc/zprofile messing up our carefully constructed PATH. So we
# need to manually load the other files we care about.
if [[ "$OSTYPE" == "darwin"* ]] && [ -f "/etc/zshrc" ]; then
  source "/etc/zshrc";
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
zplug "lib/completion", from:oh-my-zsh, defer:1
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
# Private Dotfiles
# ==============================================================================

if [ -f "$DOTPFILES/zshrc" ]; then
  source "$DOTPFILES/zshrc"
fi


# ==============================================================================
# Completion
# ==============================================================================

# Enable bash-style completion.
autoload -Uz +X compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit

fpath=("$DOTZSH/completion" "${fpath[@]}")


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


# ==============================================================================
# Local Overrides
# ==============================================================================

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi
