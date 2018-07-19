#
# Z-Shell Init
#

# Basic stuff.
DISABLE_AUTO_TITLE="true"

# Export path variables.
DOTZSH="$DOTSHELL/zsh"
ZPLUG_HOME="$DOTZSH/zplug"
ZPLUG_CACHE_DIR="$DOTZSH/zplug-cache/cache"
ZPLUG_REPOS="$DOTZSH/zplug-cache/repos"

# Don't wrap these commands in a Bundler wrapper.
UNBUNDLED_COMMANDS=(shotgun)

#
# zplug
#

source "$DOTZSH/zplug/init.zsh"
alias zp="zplug"

zplug "lib/history", from:oh-my-zsh, defer:0
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

#
# Basic Z-Shell settings
#

# Enable bash-style completion.
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Disable shared history.
unsetopt share_history

# Disable attempted correction of commands (is wrong 98% of the time).
unsetopt correctall

# Cause I hit emacs shorts too much.
# bindkey -s "\C-x\C-f" "cd "
