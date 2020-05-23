#! /usr/bin/env bash
set -e

PREFIX="/opt/emacs"

show-help() {
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
    build-essential \
    libghc-gconf-dev \
    libgif-dev \
    libgnutls-dev \
    libgpm-dev \
    libjpeg-dev \
    libm17n-dev \
    libmagick++-dev \
    libmagickcore-dev \
    libncurses5-dev \
    libotf-dev \
    libpng12-dev \
    librsvg2-dev \
    libtiff4-dev \
    libx11-dev \
    libxft-dev \
    libxml2-dev \
    xaw3dg-dev
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

main "$@"
