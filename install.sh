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
  config/kitty/kitty.conf
  config/rtx/config.toml
  config/solargraph/config.yml
  config/starship.toml
  erlang
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
  rustfmt.toml
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
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" symlinks
  fi

  # Symlink each path
  for i in "${SYMLINKS[@]}"; do
    dot_symlink "$i" "$SYMLINK_PATH" "$TARGET"
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
    "$ROOT_PATH/$PRIVATE_PATH/install.sh" launch-agents
  fi
}

install_xbar_scripts() {
  mkdir -p "$HOME/Library/Application Support/xbar/plugins"
  for file in $ROOT_PATH/xbar/*; do
    symlink "$file" "$HOME/Library/Application Support/xbar/plugins/$(basename "$file")"
  done
}

install_terminfo() {
  for file in $ROOT_PATH/terminfo/*.terminfo; do
    log ok "tic -x" "$file"
    tic -x "$file"
  done
}

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_rbenv() {
  git_clone 'https://github.com/rbenv/rbenv.git' "$TARGET/.rbenv"
  git_clone 'https://github.com/rbenv/ruby-build.git' "$TARGET/.rbenv/plugins/ruby-build"
}

install_emacs_config() {
  git_clone 'https://github.com/plexus/chemacs2.git' "$TARGET/.config/chemacs2"
  symlink "$TARGET/.config/chemacs2" "$TARGET/.emacs.d"
  git_clone 'git@github.com:jimeh/.emacs.d.git' "$TARGET/.config/emacs-siren"
}

install_rustup() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

#
# Helper functions
#

# Colors
C_RED="$(tput setaf 1)"
C_GREEN="$(tput setaf 2)"
C_YELLOW="$(tput setaf 3)"
C_BLUE="$(tput setaf 4)"
C_MAGENTA="$(tput setaf 5)"
C_CYAN="$(tput setaf 6)"
C_GREY="$(tput setaf 7)"
C_RESET="$(tput sgr0)"

# Symbols
S_RARROW="${C_CYAN}-->${C_RESET}"

log() {
  local type="$1"
  local prefix="$2"
  shift 2
  local message="$@"

  type="$(echo "$type" | tr '[:lower:]' '[:upper:]')"
  case "$type" in
    OK)
      type="${C_GREEN}${type}:${C_RESET}"
      ;;
    WARN | ERROR)
      type="${C_RED}${type}:${C_RESET}"
      ;;
    *)
      type="${C_YELLOW}${type}:${C_RESET}"
      ;;
  esac

  if [ -n "$prefix" ]; then
    prefix="${C_GREY}${prefix}: ${C_RESET}"
  fi

  printf "${type}\t${prefix}${message}\n"
}

symlink() {
  local source="$1"
  local target="$2"
  local target_dir
  local linksource

  if [ "$target" == "$source" ]; then
    log ok symlink "$target"
  elif [ ! -e "$target" ] && [ ! -L "$target" ]; then
    log link symlink "$target ${S_RARROW} $source"

    target_dir="$(dirname "$target")"
    if [ ! -d "$target_dir" ]; then
      mkdir -p "$target_dir"
    fi
    ln -s "$source" "$target"
  elif [ -L "$target" ]; then
    linksource="$(readlink "$target")"
    if [ "$linksource" == "$source" ]; then
      log ok symlink "$target ${S_RARROW} $source"
    else
      log warn symlink "$target ${S_RARROW} $linksource" \
        "${C_CYAN}(should be ${C_RESET}$source${C_CYAN})${C_RESET}"
    fi
  elif [ -f "$target" ]; then
    log warn symlink "$target exists and is a file"
  elif [ -d "$target" ]; then
    log warn symlink "$target exists and is a directory"
  else
    log warn symlink "$target exists"
  fi
}

dot_symlink() {
  local name="$1"
  local source="$2/${name}"
  local target="$3/.${name}"
  local cur_name

  if [ "$(dirname "$name")" != "." ] && [ "$(dirname "$name")" != "/" ]; then
    cur_name="$(dirname "$name")"
    while [ "$cur_name" != "." ] && [ "$cur_name" != "/" ]; do
      source="../${source}"
      cur_name="$(dirname "$cur_name")"
    done
  fi

  symlink "$source" "$target"
}

git_clone() {
  local clone_url="$1"
  local target="$2"

  if [ ! -e "$target" ]; then
    git clone "$clone_url" "$target"
    log ok git-clone "$clone_url ${S_RARROW} $target"
  else
    log info git-clone "$target already exists"
  fi
}

zsh_init() {
  zsh -l -i -c 'exit'
}

#
# Argument Handling
#

display_help() {
  echo 'usage: ./install.sh [-h/--help] [<command>]'
  echo ''
  echo 'Available commands:'
  echo '        <none>: Run symlinks and shell_init commands.'
  echo '      symlinks: Install symlinks for dotfiles into target directory.'
  echo '    shell_init: Launch zsh instance so zinit installs all deps.'
  echo '          info: Display target and source directory information.'
  echo '  emacs_config: Install Emacs configuration.'
  echo '       private: Install private dotfiles.'
  echo '      homebrew: Install Homebrew (Mac OS X only).'
  echo '         rbenv: Install rbenv, a Ruby version manager.'
  echo ' launch_agents: Install launchd plists to ~/Library/LaunchAgents/'
  echo '          help: Display this message.'
}

if [[ " $* " == *" --help "* ]] || [[ " $* " == *" -h "* ]]; then
  display_help
  exit
fi

case "$1" in
  "help")
    display_help
    ;;
  emacs_config | emacs-config | emacs)
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
  rustup | rust)
    install_rustup
    ;;
  launch_agents | launch-agents | agents)
    install_launch_agents
    ;;
  xbar_scripts | xbar-scripts | xbar)
    install_xbar_scripts
    ;;
  terminfo)
    install_terminfo
    ;;
  info)
    echo "Target directory: $TARGET"
    echo "Detected dotfiles root: $ROOT_PATH"
    ;;
  shell_init | shell-init)
    zsh_init
    ;;
  symlinks | links)
    install_symlinks
    ;;
  *)
    install_symlinks
    zsh_init
    ;;
esac
