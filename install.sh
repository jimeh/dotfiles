#! /usr/bin/env bash

#
# Configuration
#

TARGET=$HOME
DOTFILES_LINK='.dotfiles'
PRIVATE_PATH='private'
SYMLINK=(bundle emacs.d erlang gemrc gitconfig gitignore hgrc irbrc \
    powconfig rspec tmux.conf)

#
# Main Functions
#

install_symlinks () {
    # Symlink dotfiles root
    symlink "$ROOT_PATH" "$TARGET/$DOTFILES_LINK"

    # Setup private dotfiles
    local private_rakefile="$ROOT_PATH/$PRIVATE_PATH/Rakefile"
    if [ -f "$private_rakefile" ]; then
        rake --rakefile="$private_rakefile" symlink
    fi

    # Symlink each path
    for i in ${SYMLINK[@]}; do
        symlink "$DOTFILES_LINK/$i" "$TARGET/.$i"
    done

    # Symlink shell init file for bash and zsh
    for i in profile zprofile; do
        symlink "$DOTFILES_LINK/load_shellrc.sh" "$TARGET/.$i"
    done
}

install_homebrew () {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
}

install_rbenv () {
    git_clone 'git://github.com/sstephenson/rbenv.git' "$TARGET/.rbenv"
}

isntall_nvm () {
    git_clone 'https://github.com/creationix/nvm.git' "$TARGET/.nvm"
}

install_virtualenv () {
    curl -s https://raw.github.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | bash
}


#
# Initial Setup
#

if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ] ; then
    ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
elif [ -n "$0" ] && [ -f "$0" ]; then
    ROOT_PATH="$( cd "$( dirname "$0" )" && pwd )"
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
    target)
        echo "Target directory is: $TARGET"
        ;;
    symlinks|links)
        echo 'Installing: symlinks...'
        install_symlinks
        ;;
    homebrew|brew)
        echo 'Installing: Homebrew...'
        install_homebrew
        ;;
    rbenv)
        echo 'Installing: rbenv...'
        install_rbenv
        ;;
    nvm)
        echo 'Installing: nvm...'
        install_nvm
        ;;
    virtualenv|venv)
        echo 'Installing: virtualenv-burrito...'
        install_virtualenv
        ;;
    *)
        echo 'usage: ./install.sh [command]'
        echo ''
        echo 'Available commands:'
        echo '     target: Print target directory used by other commands.'
        echo '   symlinks: Install symlinks for various dotfiles into' \
             'target directory.'
        echo '   homebrew: Install Homebrew (Mac OS X only).'
        echo '      rbenv: Install rbenv, a Ruby version manager.'
        echo '        nvm: Install nvm, a Node.js version manager.'
        echo ' virtualenv: Install virtualenv-burrito, a Python version and' \
             'environment manager.'
        ;;
esac
