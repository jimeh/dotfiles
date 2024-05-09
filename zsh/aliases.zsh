#
# Aliases
#

# System
alias s="ssh"
alias ec="echo"
alias ls="ls -B"
alias l="ls -lah"
alias ll="ls -lah"
alias duh="du -h"

# Helpers
alias reload="exec $SHELL -l"

# Editors
alias t="mate"
alias e="$DOTBIN/emacsclient-wrapper"
alias eg="$DOTBIN/emacs-gui-client"
alias egs="$DOTBIN/emacs-gui-server"

# Tools
alias g="git"
alias ma="make"
alias va="vagrant"
alias tf="terraform"
alias di="colordiff"
alias devnullsmtp="java -jar $DOTBIN/DevNullSmtp.jar"

# Homebrew
if command-exists brew; then
  alias br="brew"
  alias bb="brew bundle"
  alias bbg="brew bundle --global"

  cask() {
    local cmd="$1"
    shift 1
    brew "$cmd" --cask "$@"
  }
  alias ca="cask"
fi

# Flutter
if command-exists flutter; then
  alias fl="flutter"
fi

# hwatch
if command-exists hwatch; then
  alias wa="hwatch"
fi

# Misc.
alias weechat="TERM=screen-256color weechat-curses"
alias slashdot="ab -kc 50 -t 300"
alias digg="ab -kc 50 -t 30"
alias fact="elinks -dump randomfunfacts.com | sed -n '/^| /p' | tr -d \|"
alias servethis="python -m http.server"
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'''
alias fku="fuck you"
alias fucking="sudo"

# Improved myip alias. Echoed to avoid strange character at end in ZSH.
myip() {
  echo "$(curl -s whatismyip.akamai.com)"
}

# appends your key to a server's authorized keys file
alias authme="ssh-copy-id"

# Make and cd into directory
#  - from: http://alias.sh/make-and-cd-directory
mcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract most common archives with single command.
#  - from: http://alias.sh/extract-most-know-archives-one-command
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)  tar xvjf $1    ;;
      *.tar.gz)   tar xvzf $1    ;;
      *.tar.xz)   tar xvJf $1    ;;
      *.bz2)      bunzip2 $1     ;;
      *.rar)      unrar e $1     ;;
      *.gz)       gunzip $1      ;;
      *.tar)      tar xvf $1     ;;
      *.tbz2)     tar xvjf $1    ;;
      *.tbz)      tar xvjf $1    ;;
      *.tgz)      tar xvzf $1    ;;
      *.txz)      tar xvJf $1    ;;
      *.zip)      unzip $1       ;;
      *.Z)        uncompress $1  ;;
      *.7z)       7z x $1        ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
alias ext=extract
