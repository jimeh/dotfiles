#
# rbenv (Ruby version manager) setup.
#

# ==============================================================================
# Lazy-load rbenv
# ==============================================================================

rbenv() {
  load-rbenv
  rbenv "$@"
}

_rbenv() {
  load-rbenv
  _rbenv "$@"
}

compctl -K _rbenv rbenv

load-rbenv() {
  unset -f load-rbenv _rbenv rbenv
  eval "$(command rbenv init -)"
}

# ==============================================================================
# Plugins
# ==============================================================================

zinit ice as'program' pick'bin/rbenv-each' from'gh'
zinit light rbenv/rbenv-each

# ==============================================================================
# Misc.
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

upgrade-bundler() {
  rbenv each -v gem install --no-document 'bundler:~> 1.0' 'bundler:~> 2.0'
}
