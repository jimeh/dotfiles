#
# Homebrew related stuff.
#

install_brew_global_packages () {
  # Basic packages.
  brew install \
       ack \
       android-sdk \
       bash \
       bazaar \
       git \
       heroku \
       htop \
       kubernetes-cli \
       peco \
       readline \
       reattach-to-user-namespace \
       the_silver_searcher \
       tmux \
       wget \
       zsh

  brew install aspell --with-lang-en --with-lang-el --with-lang-sv

  # Services.
  brew install \
       mysql \
       redis
}
