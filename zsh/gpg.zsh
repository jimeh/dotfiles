#
# GnuPG
#

gpg-warm-cache() {
  local key="${1:-$(git config user.signingkey 2>/dev/null)}"
  local gpg_args=(--clearsign)

  if [ -n "$key" ]; then
    gpg_args=(--local-user "$key" "${gpg_args[@]}")
  fi

  printf "warm gpg-agent cache\n" | gpg "${gpg_args[@]}" >/dev/null
}

alias gpg-warm="gpg-warm-cache"
