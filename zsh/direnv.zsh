#
# direnv setup
#

zinit ice wait lucid from'gh-r' as'program' mv'direnv* -> direnv' \
  atclone'./direnv hook zsh > .zinitrc.zsh' atpull'%atclone' \
  pick'direnv' src='.zinitrc.zsh'
zinit light direnv/direnv
