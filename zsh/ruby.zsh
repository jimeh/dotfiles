#
# Ruby environment setup.
#

install_ruby_global_packages() {
  local packages=(
    'bundler:~> 1.0'
    'bundler:~> 2.0'
    brakeman
    bundler-audit
    foreman
    lunchy
    method_source
    procodile
    pry-doc
    reek
    rubocop
    rubocop-daemon
    schmersion
    seeing_is_believing
    solargraph
  )

  gem install --no-document rbenv-rehash
  gem install --no-document "${packages[@]}"
}

# Aliases
alias po="powify"
alias lu="lunchy"
alias he="heroku"
alias f="foreman"
alias fs="foreman start"
alias fr="foreman run"
alias pe="procodile exec"
alias sm="schmersion"

# Aliases for specific ruby commands
alias ru="bundle exec ruby"
alias ra="bundle exec rake"
alias rai="bundle exec rails"
alias rs="bundle exec rspec -f doc"
alias cu="bundle exec cucumber"
alias scu="RAILS_ENV=cucumber bundle exec spring cucumber"

# Bundler aliases
alias bch="bundle check"
alias bcn="bundle clean"
alias bco="bundle console"
alias be="bundle exec"
alias bi="bundle_install"
alias bl="bundle list"
alias bo="bundle open"
alias bp="bundle package"
alias bu="bundle update"

if command-exists rbenv; then
  source "$DOTZSH/rbenv.zsh"
fi
