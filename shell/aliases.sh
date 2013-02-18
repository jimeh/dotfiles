#
# Aliases
#

# System
alias o="open"
alias s="ssh"
alias ec="echo"
alias ls="ls -BG"
alias l="ls -lah"
alias ll="ls -lah"
alias duh="du -h"

# Helpers
alias reload="source ~/.profile"

# Editors
alias n="nano"
alias t="mate"
alias e="$DOTBIN/emacsclient-wrapper"
alias eg="$DOTBIN/emacs-gui-client"
alias egs="$DOTBIN/emacs-gui-server"

# Utils
alias ma="make"
alias br="brew"
alias devnullsmtp="java -jar $DOTBIN/DevNullSmtp.jar"

# Misc.
alias weechat="TERM=screen-256color weechat-curses"
alias slashdot="ab -kc 50 -t 300"
alias digg="ab -kc 50 -t 30"
alias fact="elinks -dump randomfunfacts.com | sed -n '/^| /p' | tr -d \|"
alias netlisteners='lsof -i -P | grep LISTEN'
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'''
alias myip='curl ifconfig.me'

# appends your key to a server's authorized keys file
function authme {
  ssh "$1" 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' \
    < ~/.ssh/id_dsa.pub
}

# Make and cd into directory
#  - from: http://alias.sh/make-and-cd-directory
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# Extract most common archives with single command.
#  - from: http://alias.sh/extract-most-know-archives-one-command
function extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tbz)       tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
