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
