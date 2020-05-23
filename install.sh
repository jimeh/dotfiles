#! /usr/bin/env bash

#
# Configuration
#

TARGET="$HOME"
DOTFILES_LINK=".dotfiles"
SYMLINK_PATH="$DOTFILES_LINK"
PRIVATE_PATH="private"
SYMLINKS=(
  Brewfile
  ackrc
  alacritty.yml
  bitbar
  coffeelint.json
  erlang
  eslintrc.js
  gemrc
  gitconfig
  gitignore
  hammerspoon
  hgrc
  hyper.js
  irbrc
  peco
  powconfig
  pryrc
  reek.yml
  rspec
  rubocop.yml
  solargraph.yml
  tmux
  tmux.conf
  zshenv
  zshrc
)

#
# Initial Setup
#

if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  ROOT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
elif [ -n "$0" ] && [ -f "$0" ]; then
  ROOT_PATH=$(cd "$(dirname "$0")" && pwd)
else
  echo "[ERROR] Can't determine dotfiles' root path."
  exit 1
fi

#
# Main Functions
#

install_symlinks() {
  # Symlink dotfiles root
  symlink "$ROOT_PATH" "$TARGET/$DOTFILES_LINK"

  # Setup private dotfiles
  if [ -f "$ROOT_PATH/$PRIVATE_PATH/install.sh" ]; then
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" links
  fi

  # Symlink each path
  for i in "${SYMLINKS[@]}"; do
    symlink "$SYMLINK_PATH/$i" "$TARGET/.$i"
  done
}

install_private() {
  git_clone "git@github.com:jimeh/dotfiles-private.git" \
    "$ROOT_PATH/$PRIVATE_PATH"
}

install_launch_agents() {
  mkdir -p "$HOME/Library/LaunchAgents"
  for file in $ROOT_PATH/launch_agents/*.plist; do
    symlink "$file" "$HOME/Library/LaunchAgents/$(basename "$file")"
  done

  # Setup private launch_agents
  if [ -f "$ROOT_PATH/$PRIVATE_PATH/install.sh" ]; then
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" launch_agents
  fi
}

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_rbenv() {
  git_clone 'https://github.com/rbenv/rbenv.git' "$TARGET/.rbenv"
  git_clone 'https://github.com/rbenv/ruby-build.git' "$TARGET/.rbenv/plugins/ruby-build"
}

install_emacs_config() {
  git_clone 'https://github.com/plexus/chemacs.git' "$TARGET/.config/chemacs"
  symlink "$TARGET/.config/chemacs/.emacs" "$TARGET/.emacs"
  git_clone 'git@github.com:jimeh/.emacs.d.git' "$TARGET/.emacs.d"
}

#
# Helper functions
#

ok() {
  printf "OK:\t%s\n" "$1"
}

info() {
  printf "INFO:\t%s\n" "$1"
}

symlink() {
  local source="$1"
  local target="$2"

  if [ ! -e "$target" ]; then
    ok "symlink: $target --> $source"
    ln -s "$source" "$target"
  else
    info "symlink: $target exists"
  fi
}

git_clone() {
  local clone_url="$1"
  local target="$2"

  if [ ! -e "$target" ]; then
    git clone "$clone_url" "$target"
    ok "git clone: $clone_url --> $target"
  else
    info "git clone: $target already exists"
  fi
}

#
# Argument Handling
#

case "$1" in
  symlinks | links)
    install_symlinks
    ;;
  emacs-config | emacs)
    install_emacs_config
    ;;
  private)
    install_private
    ;;
  homebrew | brew)
    install_homebrew
    ;;
  rbenv)
    install_rbenv
    ;;
  launch_agents | agents)
    install_launch_agents
    ;;
  info)
    echo "Target directory: $TARGET"
    echo "Detected dotfiles root: $ROOT_PATH"
    ;;
  *)
    echo 'usage: ./install.sh [command]'
    echo ''
    echo 'Available commands:'
    echo '          info: Target and source directory info.'
    echo '      symlinks: Install symlinks for various dotfiles into' \
      'target directory.'
    echo '  emacs_config: Install Emacs configuration.'
    echo '       private: Install private dotfiles.'
    echo '      homebrew: Install Homebrew (Mac OS X only).'
    echo '         rbenv: Install rbenv, a Ruby version manager.'
    echo ' launch_agents: Install launchd plists to ~/Library/LaunchAgents/'
    ;;
esac
