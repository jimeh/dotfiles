#! /usr/bin/env bash
set -e

PREFIX="/opt/tmux"

help() {
  echo "usage: ./install-tmux.sh <VERSION>"
}

install() {
  local version="$1"
  mkdir -p /tmp/tmux-src
  cd /tmp/tmux-src
  if [ ! -d "tmux-${version}" ]; then
    if [ ! -f "tmux-${version}.tar.gz" ]; then
      wget "https://github.com/tmux/tmux/releases/download/${version}/tmux-${version}.tar.gz"
    fi
    tar -zxf "tmux-${version}.tar.gz"
  fi
  cd "tmux-${version}"
  ./configure --prefix="$PREFIX" && make && sudo make install
}

deps() {
  sudo apt-get update
  sudo apt-get install -y \
       bc \
       build-essential \
       libevent-dev \
       libncurses5-dev
}

main() {
  local command="$1"

  if [ -z "$command" ]; then
    echo "$(help)" 1>&2
    exit 1
  fi

  if [ "$command" == "deps" ]; then
    deps
  else
    install "$command"
  fi
}

main $@
