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

# zplug "junegunn/fzf", of:"shell/*.zsh"
zplug "jimeh/zsh-peco-history"

zplug "b4b4r07/enhancd", of:"zsh/*.zsh"
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

if zplug check "b4b4r07/enhancd"; then
  export ENHANCD_COMMAND=c
  export ENHANCD_FILTER="fzf:peco --layout=bottom-up"
fi

# Configure zsh-syntax-highlighting
if zplug check zsh-users/zsh-syntax-highlighting; then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi

zplug load
