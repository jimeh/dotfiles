#
# GnuPG
#

gpg-refresh-tty() {
  local tty_name="$(tty 2>/dev/null)"

  if [ -n "$tty_name" ] && [ "$tty_name" != "not a tty" ]; then
    export GPG_TTY="$tty_name"

    if command -v gpg-connect-agent >/dev/null 2>&1; then
      gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
    fi
  fi
}

gpg-warm-cache() {
  local key="${1:-${GPG_WARM_KEY:-$(git config user.signingkey 2>/dev/null)}}"
  local gpg_args=(--clearsign)

  if [ -n "$key" ]; then
    gpg_args=(--local-user "$key" "${gpg_args[@]}")
  fi

  gpg-refresh-tty
  printf "warm gpg-agent cache\n" | gpg "${gpg_args[@]}" >/dev/null
}

alias gpg-warm="gpg-warm-cache"
