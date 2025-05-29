#
# Ruby environment setup.
#

# ==============================================================================
# bundler
# ==============================================================================

# Enable Ruby Bundler plugin from oh-my-zsh.
zinit for @OMZ::plugins/bundler

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

# ==============================================================================
# global ruby packages
# ==============================================================================

install_ruby_global_packages() {
  local packages=(
    'bundler:~> 1.0'
    'bundler:~> 2.0'
    bundler-audit
    dotenv
    erb_lint
    foreman
    method_source
    pry-doc
    reek
    rubocop
    ruby-lsp
    ruby-lsp-rails
    ruby-lsp-rspec
    solargraph
    solargraph-rails
    steep
    syntax_tree
    syntax_tree-haml
    syntax_tree-rbs
    yard
  )

  gem install --no-document "${packages[@]}"
}
