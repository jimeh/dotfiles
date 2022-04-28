#
# direnv setup
#

zinit light-mode wait lucid from'gh-r' as'program' pick'direnv' \
  mv'direnv* -> direnv' \
  atclone'./direnv hook zsh > .zinitrc.zsh' atpull'%atclone' \
  src='.zinitrc.zsh' \
  for @direnv/direnv
