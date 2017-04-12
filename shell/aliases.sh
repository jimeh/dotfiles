#
# Aliases
#

# System
alias o="open"
alias s="ssh"
alias ec="echo"
alias mk="make"
alias ls="ls -B"
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
alias ca="brew cask"
alias cask="brew cask"
alias devnullsmtp="java -jar $DOTBIN/DevNullSmtp.jar"
alias open_ports="sudo lsof -i -P | grep --color=never -i \"listen\""

# Misc.
alias weechat="TERM=screen-256color weechat-curses"
alias slashdot="ab -kc 50 -t 300"
alias digg="ab -kc 50 -t 30"
alias fact="elinks -dump randomfunfacts.com | sed -n '/^| /p' | tr -d \|"
alias netlisteners='lsof -i -P | grep LISTEN'
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'''
alias fku="fuck you"
alias fucking="sudo"

# Fix wifi issues on OS X 10.10.x Yosemite.
#  - from: https://medium.com/@mariociabarra/wifried-ios-8-wifi-performance-issues-3029a164ce94
alias fix_wifi="sudo ifconfig awdl0 down"
alias unfix_wifi="sudo ifconfig awdl0 up"

# Disable the system built-in cmd+ctrl+d global hotkey to lookup word in
# dictionary on OS X. Must reboot after running.
#  - from: ://apple.stackexchange.com/a/114269
osx-disable-lookup-word-hotkey() {
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 \
           '<dict><key>enabled</key><false/></dict>'
  echo "Command-Control-D hotkey disabled. Please reboot to take effect."
}

# Improved myip alias. Echoed to avoid strange character at end in ZSH.
function myip {
  echo "$(curl -s whatismyip.akamai.com)"
}

# appends your key to a server's authorized keys file
function authme {
  ssh "$1" 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' \
    < ~/.ssh/id_rsa.pub
}

# ssh commands related to old SSH keys
alias ssho="ssh -i ~/.ssh/old-id_rsa"
function authmeo {
  ssh -i ~/.ssh/old-id_rsa "$1" \
    'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' \
    < ~/.ssh/id_rsa.pub
}

# Make and cd into directory
#  - from: http://alias.sh/make-and-cd-directory
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# Open man page in Preview.
pman () {
  man -t "${1}" | open -f -a /Applications/Preview.app
}

# Extract most common archives with single command.
#  - from: http://alias.sh/extract-most-know-archives-one-command
function extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xvjf $1    ;;
        *.tar.gz)    tar xvzf $1    ;;
        *.tar.xz)    tar xvJf $1    ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xvjf $1    ;;
        *.tbz)       tar xvjf $1    ;;
        *.tgz)       tar xvzf $1    ;;
        *.txz)       tar xvJf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
alias ext=extract


# Show hidden files in Finder.
function show_files {
  defaults write com.apple.finder AppleShowAllFiles YES
  killall Finder "/System/Library/CoreServices/Finder.app"
}

# Don't show hidden files in Finder.
function hide_files {
  defaults write com.apple.finder AppleShowAllFiles NO
  killall Finder "/System/Library/CoreServices/Finder.app"
}
