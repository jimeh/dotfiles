#
# Rclone
#

zinit ice wait lucid as'program' from'gh-r' mv'**/rclone -> rclone' \
  atclone'./rclone genautocomplete zsh - > _rclone' atpull'%atclone'
zinit light rclone/rclone
