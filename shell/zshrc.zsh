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

zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh", defer:0

zplug "plugins/bundler", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh

zplug "aaronjamesyoung/aaron-zsh-theme", use:"aaron.zsh-theme", defer:3
# zplug "$DOTZSH/themes/plain", from:local, use:"plain.zsh-theme", defer:3

zplug "jimeh/zsh-peco-history"
zplug "b4b4r07/enhancd", use:"init.sh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

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

# source "$DOTZSH/themes/plain/plain.zsh-theme"

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
