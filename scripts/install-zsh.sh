#! /usr/bin/env bash
set -e

PREFIX="/opt/zsh"

show-help() {
  echo "usage: ./install-zsh.sh <VERSION>"
}

install() {
  local version="$1"
  mkdir -p /tmp/zsh-src
  cd /tmp/zsh-src
  if [ ! -d "zsh-${version}" ]; then
    if [ ! -f "zsh-${version}.tar.gz" ]; then
      wget "http://downloads.sourceforge.net/project/zsh/zsh/${version}/zsh-${version}.tar.gz"
    fi
    tar -zxf "zsh-${version}.tar.gz"
  fi
  cd "zsh-${version}"
  ./configure --prefix="$PREFIX" && make && sudo make install
}

deps() {
  sudo apt-get update
  sudo apt-get install -y \
    build-essential
}

main() {
  local command="$1"

  if [ -z "$command" ]; then
    show-help 1>&2
    exit 1
  fi

  if [ "$command" == "deps" ]; then
    deps
  else
    install "$command"
  fi
}

main $@
