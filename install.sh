#! /usr/bin/env bash

#
# Configuration
#

TARGET="$HOME"
DOTFILES_LINK=".dotfiles"
SYMLINK_PATH="$DOTFILES_LINK"
PRIVATE_PATH="private"
SYMLINKS=(
  ackrc
  bundle
  coffeelint.json
  emacs.d
  erlang
  eslintrc.js
  gemrc
  gitconfig
  gitignore
  hgrc
  hyper.js
  irbrc
  peco
  powconfig
  rspec
  rubocop.yml
  tmux
  tmux.conf
)
LOAD_FILES=(profile zshrc)

#
# Main Functions
#

install_symlinks () {
  # Symlink dotfiles root
  symlink "$ROOT_PATH" "$TARGET/$DOTFILES_LINK"

  # Setup private dotfiles
  if [ -f "$ROOT_PATH/$PRIVATE_PATH/install.sh" ]; then
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" links
  fi

  # Symlink each path
  for i in ${SYMLINKS[@]}; do
    symlink "$SYMLINK_PATH/$i" "$TARGET/.$i"
  done

  # Symlink shell init file for bash and zsh
  for i in ${LOAD_FILES[@]}; do
    symlink "$DOTFILES_LINK/load_shellrc.sh" "$TARGET/.$i"
  done
}

install_private () {
  git_clone "git@github.com:jimeh/dotfiles-private.git" \
            "$ROOT_PATH/$PRIVATE_PATH"
}

install_launch_agents () {
  mkdir -p "$HOME/Library/LaunchAgents"
  for file in $ROOT_PATH/launch_agents/*.plist; do
    symlink "$file" "$HOME/Library/LaunchAgents/$(basename "$file")"
  done

  # Setup private launch_agents
  if [ -f "$ROOT_PATH/$PRIVATE_PATH/install.sh" ]; then
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" agents
  fi
}

install_homebrew () {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
}

install_rbenv () {
  git_clone 'https://github.com/rbenv/rbenv.git' "$TARGET/.rbenv"
  git_clone 'https://github.com/rbenv/ruby-build.git' "$TARGET/.rbenv/plugins/ruby-build"
}

install_nvm () {
  git_clone 'https://github.com/creationix/nvm.git' "$TARGET/.nvm"
}

install_gvm () {
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
}

install_virtualenv () {
  curl -s https://raw.github.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | bash
}

install_dokku() {
  git_clone 'https://github.com/progrium/dokku.git' "$TARGET/.dokku"
}


#
# Initial Setup
#

if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ] ; then
  ROOT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
elif [ -n "$0" ] && [ -f "$0" ]; then
  ROOT_PATH=$(cd "$(dirname "$0")" && pwd)
else
  echo "[ERROR] Can't determine dotfiles' root path."
  exit 1
fi


#
# Helper functions
#

symlink() {
  if [ ! -e "$2" ]; then
    echo "   symlink: $2 --> $1"
    ln -s "$1" "$2"
  else
    echo "    exists: $2"
  fi
}

git_clone () {
  if [ ! -e "$2" ]; then
    git clone "$1" "$2"
  else
    echo "[ERROR] $2 already exists"
  fi
}


#
# Argument Handling
#

case "$1" in
  symlinks|links)
    install_symlinks
    ;;
  private)
    install_private
    ;;
  homebrew|brew)
    install_homebrew
    ;;
  rbenv)
    install_rbenv
    ;;
  nvm)
    install_nvm
    ;;
  gvm)
    install_gvm
    ;;
  virtualenv|venv)
    install_virtualenv
    ;;
  dokku)
    install_dokku
    ;;
  launch_agents|agents)
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
    echo '       private: Install private dotfiles.'
    echo '      homebrew: Install Homebrew (Mac OS X only).'
    echo '         rbenv: Install rbenv, a Ruby version manager.'
    echo '           nvm: Install nvm, a Node.js version manager.'
    echo '           gvm: Install gvm, a Go version manager.'
    echo '    virtualenv: Install virtualenv-burrito, a Python version and' \
         'environment manager.'
    echo '         dokku: Clone dokku to ~/.dokku enabling use of' \
         'dokku_client.sh.'
    echo ' launch_agents: Install launchd plists to ~/Library/LaunchAgents/'
    ;;
esac
