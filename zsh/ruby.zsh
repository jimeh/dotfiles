#
# Ruby environment setup.
#

install_ruby_global_packages () {
  gem install --no-document \
      brakeman \
      bundler \
      bundler-audit \
      foreman \
      lunchy \
      method_source \
      pry-doc \
      rbenv-rehash \
      reek \
      rubocop \
      seeing_is_believing \
      solargraph
}

# Aliases
alias po="powify"
alias lu="lunchy"
alias he="heroku"
alias f="foreman"
alias fs="foreman start"
alias fr="foreman run"

# Aliases for specific ruby commands
alias ru="bundle exec ruby"
alias ra="bundle exec rake"
alias rai="bundle exec rails"
alias rs="bundle exec rspec -f doc"
alias cu="bundle exec cucumber"
alias scu="RAILS_ENV=cucumber bundle exec spring cucumber"
alias va="vagrant"

alias bc="bundle check"
alias bco="bundle console"

if [ -n "$BASH_VERSION" ]; then
  # Bundler aliases
  alias be="bundle exec"
  alias bl="bundle list"
  alias bp="bundle package"
  alias bo="bundle open"
  alias bu="bundle update"
  alias bi="bundle_install"
  alias bcn="bundle clean"
fi

# lazy-load rbenv
if [ -d "$HOME/.rbenv/shims" ]; then
  path_prepend "$HOME/.rbenv/shims"
fi

rbenv() {
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# lunchy auto-completion
if [ -n "$BASH_VERSION" ]; then
  if which gem &> /dev/null && gem which lunchy &> /dev/null; then
    LUNCHY_DIR="$(dirname "$(gem which lunchy)")/../extras"
    if [ -f "$LUNCHY_DIR/lunchy-completion.bash" ]; then
      source "$LUNCHY_DIR/lunchy-completion.bash"
    fi
  fi
fi
