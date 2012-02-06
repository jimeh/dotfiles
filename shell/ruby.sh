# Aliases
alias po="powify"
alias lu="lunchy"

# Bundler aliases
alias bi="bundle install --path vendor/bundle --binstubs=.bin"
alias bc="bundle check"
alias bl="bundle list"
alias be="bundle exec"
alias bu="bundle update"
alias bco="bundle console"

# Bundler aliases for specific ruby commands
alias ru="bundle exec ruby"
alias ra="bundle exec rake"
alias rai="bundle exec rails"
alias rs="bundle exec rspec"
alias ca="bundle exec cap"
alias cu="bundle exec cucumber"
alias va="bundle exec vagrant"

# Load rbenv or RVM depending on which is available
if [ -d "$HOME/.rbenv/bin" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
elif [ -s "$HOME/.rvm/scripts/rvm" ]; then
    source "$HOME/.rvm/scripts/rvm"
fi
