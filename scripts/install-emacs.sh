#! /usr/bin/env bash
set -e

PREFIX="/opt/emacs"

help() {
  echo "usage: ./install-emacs.sh <VERSION>"
}

install() {
  local version="$1"
  mkdir -p /tmp/emacs-src
  cd /tmp/emacs-src
  if [ ! -d "emacs-${version}" ]; then
    if [ ! -f "emacs-${version}.tar.gz" ]; then
      wget "http://ftp.gnu.org/gnu/emacs/emacs-${version}.tar.gz"
    fi
    tar -zxf "emacs-${version}.tar.gz"
  fi
  cd "emacs-${version}"
  ./configure --prefix="$PREFIX" && make && sudo make install
}

deps() {
  sudo apt-get update
  sudo apt-get install -y \
       build-essential libx11-dev xaw3dg-dev libjpeg-dev libpng12-dev \
       libgif-dev libtiff4-dev libncurses5-dev libxft-dev librsvg2-dev \
       libmagickcore-dev libmagick++-dev libxml2-dev libgpm-dev \
       libghc-gconf-dev libotf-dev libm17n-dev libgnutls-dev
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
