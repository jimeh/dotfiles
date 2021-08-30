#
# Scaleway CLI setup.
#

if command-exists scw; then
  _scw() {
    unset -f _scw
    eval "$(command scw autocomplete script shell=zsh)"
  }
  compctl -K _scw scw
fi
