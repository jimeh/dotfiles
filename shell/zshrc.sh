#
# Z-Shell Init
#

# Export path variables
DOTZSH="$DOTSHELL/zsh"

# Path to your oh-my-zsh configuration.
ZSH="$DOTZSH/oh-my-zsh"

# Customize oh-my-zsh's custom path.
ZSH_CUSTOM="$DOTZSH/custom"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="plain"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew bundler cake cap gem heroku node nyan osx powder python ruby \
  thor vagrant)

source "$ZSH/oh-my-zsh.sh"

# Customize to your needs...

# Enable bash-style completion
autoload -U bashcompinit
bashcompinit

# Disable shared history
unsetopt share_history

# Disable attempted correction of commands (is wrong 98% of the time).
unsetopt correctall

# Disable certain bundled ruby binaries, I install the gems globally.
unalias foreman
unalias heroku
unalias shotgun

# Cause I hit emacs shorts too much
bindkey -s "\C-x\C-f" "cd "


#
# Z-Shell Command Highlighting
#

# Highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

source "$DOTZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


#
# Z-Shell Autosuggestions
#

source "$DOTZSH/zsh-autosuggestions/autosuggestions.zsh"

# Enable autosuggestions automatically
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^T' autosuggest-toggle
