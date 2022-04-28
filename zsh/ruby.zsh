#
# Ruby environment setup.
#

# ==============================================================================
# rbenv
# ==============================================================================

# Install rbenv
zinit light-mode wait lucid as'program' pick'bin/rbenv' from'gh' \
  atclone'src/configure && make -C src; libexec/rbenv init - > .zinitrc.zsh' \
  atpull'%atclone' src'.zinitrc.zsh' nocompile'!' \
  for @rbenv/rbenv

# install ruby-build
zinit light-mode wait lucid as'program' pick'bin/ruby-build' from'gh' \
  for @rbenv/ruby-build

# install rbenv-each plugin
zinit light-mode wait lucid as'program' pick'bin/rbenv-each' from'gh' \
  for @rbenv/rbenv-each

# ==============================================================================
# aliases
# ==============================================================================

# bundler
alias bch="bundle check"
alias bcn="bundle clean"
alias bco="bundle console"
alias be="bundle exec"
alias bi="bundle_install"
alias bl="bundle list"
alias bo="bundle open"
alias bp="bundle package"
alias bu="bundle update"

# bundle exec wrappers
alias ru="bundle exec ruby"
alias ra="bundle exec rake"
alias rai="bundle exec rails"
alias rs="bundle exec rspec -f doc"
alias cu="bundle exec cucumber"
alias scu="RAILS_ENV=cucumber bundle exec spring cucumber"

# gems
alias po="powify"
alias lu="lunchy"
alias he="heroku"
alias f="foreman"
alias fs="foreman start"
alias fr="foreman run"
alias pe="procodile exec"
alias sm="schmersion"

# ==============================================================================
# global ruby packages
# ==============================================================================

install_ruby_global_packages() {
  local packages=(
    'bundler:~> 1.0'
    'bundler:~> 2.0'
    brakeman
    bundler-audit
    debase
    dotenv
    foreman
    hippo-cli
    lunchy
    method_source
    procodile
    pry-doc
    reek
    rubocop
    rubocop-daemon
    ruby-debug-ide
    schmersion
    seeing_is_believing
    solargraph
    steep
    yard
  )

  gem install --no-document rbenv-rehash
  gem install --no-document "${packages[@]}"
}

# ==============================================================================
# bundler
# ==============================================================================

upgrade-bundler() {
  rbenv each -v gem install --no-document 'bundler:~> 1.0' 'bundler:~> 2.0'
}

# ==============================================================================
# solargraph
# ==============================================================================

solargraph-install() {
  rbenv each -v gem install solargraph
}

solargraph-download-cores() {
  rbenv each -v solargraph download-core
}

solargraph-list-versions() {
  rbenv each -v gem list -q solargraph
}

rubygems-upgrade() {
  rbenv each -v gem update --system
}
