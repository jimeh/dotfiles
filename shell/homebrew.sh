#
# Homebrew related stuff.
#

bootstrap_homebrew () {
  local pkgs=(
    ack
    "aspell --with-lang-en --with-lang-el --with-lang-sv"
    bash
    bazaar
    git
    heroku
    htop
    kubernetes-cli
    mysql
    peco
    readline
    reattach-to-user-namespace
    redis
    the_silver_searcher
    tmux
    wget
    zsh
  )

  local installed=( $(brew list) )

  for pkg in ${pkgs[@]}; do
    local base=$(echo $pkg | awk '{print $1}')
    local found=""

    for i in ${installed[@]}; do
      if [[ "$base" == "$i" ]]; then
        found=1
      fi
    done

    if [ -z "$found" ]; then
      brew install "${pkg[@]}"
    fi
  done
}
