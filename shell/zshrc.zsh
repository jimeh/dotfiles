#
# Z-Shell Init
#

# Basic stuff.
DISABLE_AUTO_TITLE="true"

# Export path variables.
DOTZSH="$DOTSHELL/zsh"
ZPLUG_HOME="$DOTZSH/zplug-cache"

# Don't wrap these commands in a Bundler wrapper.
UNBUNDLED_COMMANDS=(shotgun)

# Enable bash-style completion.
autoload -U bashcompinit
bashcompinit

# Disable shared history.
unsetopt share_history

# Disable attempted correction of commands (is wrong 98% of the time).
unsetopt correctall

# Cause I hit emacs shorts too much.
bindkey -s "\C-x\C-f" "cd "

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive).
bindkey '^T' autosuggest-toggle

#
# zplug
#

source "$DOTZSH/zplug/zplug"
alias zp="zplug"

zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/bundler", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/powder", from:oh-my-zsh

zplug "$DOTZSH/themes/plain", from:local

zplug "jimeh/zsh-peco-history"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", nice:19

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo
    zplug install
  fi
fi

zplug load

# Configure zsh-syntax-highlighting
if zplug check zsh-users/zsh-syntax-highlighting; then
  export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi
