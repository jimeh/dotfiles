#
# Tmux environment setup.
#

# Aliases
alias tm="tmux"
alias tma="tm att"
alias tmn="tm new"
alias tml="tm ls"
alias tmm="tmn -s main"

# Tmuxifier

zinit light-mode wait lucid as'program' pick'bin/tmuxifier' from'gh' \
  atclone'./bin/tmuxifier init - > .tmuxifier.zsh' atpull'%atclone' \
  src='.tmuxifier.zsh' \
  for @jimeh/tmuxifier

alias m="tmuxifier"
alias ms="tmuxifier load-session"
alias mw="tmuxifier load-window"
alias mm="tmuxifier load-session main"

if [ -n "$DOTPFILES" ] && [ -d "$DOTPFILES/tmux-layouts" ]; then
  export TMUXIFIER_LAYOUT_PATH="$DOTPFILES/tmux-layouts"
else
  export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
fi

use-tmuxifier-dev() {
  path_prepend "$HOME/Projects/tmuxifier/bin"
  path_remove "$DOTFILES/tmux/tmuxifier/bin"
  export TMUXIFIER="$HOME/Projects/tmuxifier"
}
