# Aliases
alias po="powify"
alias lu="lunchy"
alias he="heroku"
alias f="foreman"
alias fs="foreman start"
alias fr="foreman run"

# Bundler aliases
alias bi="bundle install --path vendor/bundle --binstubs=vendor/bundle/bin"
alias bc="bundle check"
alias bl="bundle list"
alias be="bundle exec"
alias bu="bundle update"
alias bco="bundle console"

# Bundler aliases for specific ruby commands
if [ -n "$BASH_VERSION" ]; then
  alias ru="bundle exec ruby"
  alias ra="bundle exec rake"
  alias rai="bundle exec rails"
  alias rs="bundle exec rspec"
  alias ca="bundle exec cap"
  alias cu="bundle exec cucumber"
  alias va="bundle exec vagrant"
elif [ -n "$ZSH_VERSION" ]; then
  # With Z-Shell I use oh-my-zsh and it's bundler plugin negating the need to
  # manually prefix ruby-based commands with 'bundle exec'.
  alias ru="ruby"
  alias ra="rake"
  alias rai="rails"
  alias rs="rspec"
  alias ca="cap"
  alias cu="cucumber"
  alias va="vagrant"
fi

# Load rbenv or RVM depending on which is available
if [ -d "$HOME/.rbenv/bin" ]; then
  # Don't load rbenv again if oh-my-zsh's rbenv plugin already has
  if [[ ":$PATH:" != *":$HOME/.rbenv/bin:"* ]]; then
    path_prepend "$HOME/.rbenv/bin"
    eval "$(rbenv init -)"
  fi
elif [ -s "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
fi
