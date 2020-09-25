#
# direnv setup
#

zinit ice wait lucid from'gh-r' as'program' mv'direnv* -> direnv' \
  atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
  pick'direnv' src='zhook.zsh'
zinit light direnv/direnv
