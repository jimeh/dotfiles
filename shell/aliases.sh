#
# Aliases
#

# System
alias o="open"
alias s="ssh"
alias ls="ls -BG"
alias ll="ls -lah"
alias duh="du -h"

# Helpers
alias reload="source ~/.profile"

# Editors
alias n="nano"
alias t="mate"
alias e="$DOTBIN/emacsclient-wrapper"

# Utils
alias br="brew"
alias devnullsmtp="java -jar $DOTBIN/DevNullSmtp.jar"

# Misc.
alias weechat="TERM=screen-256color weechat-curses"
alias slashdot="ab -kc 50 -t 300"
alias digg="ab -kc 50 -t 30"
alias fact="elinks -dump randomfunfacts.com | sed -n '/^| /p' | tr -d \|"

# appends your key to a server's authorized keys file
function authme {
  ssh "$1" 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_dsa.pub
}
