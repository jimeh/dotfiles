#
# Rclone
#

zinit light-mode wait lucid as'program' from'gh-r' mv'**/rclone -> rclone' \
  atclone'./rclone genautocomplete zsh - > _rclone' atpull'%atclone' \
  for @rclone/rclone
