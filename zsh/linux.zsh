#
# Linux specific setup
#

# Aliases
alias o="xdg-open"

# Ensure 256 color support in Linux
export TERM="xterm-256color"

path_append "/opt/tigervnc/bin"

zinit ice wait lucid as'program' from'gh-r' mv'shfmt* -> shfmt' \
  atclone'./shfmt completions zsh > _shfmt' atpull'%atclone'
zinit light mvdan/sh
