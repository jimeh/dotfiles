#
# jq
#

if ! command-exists jq; then
  zinit light-mode wait lucid from'gh-r' as'program' mv'jq* -> jq' \
    for @stedolan/jq
fi
