#
# Google Cloud SDK setup.
#

# Lazy load gcloud shell completion on first use.
if command-exists gcloud; then
  _python_argcomplete() {
    load-gcloud-completion
    _python_argcomplete "$@"
  }

  compctl -K _python_argcomplete gcloud

  load-gcloud-completion() {
    unset -f load-gcloud-completion _python_argcomplete
    if [ -n "$HOMEBREW_PREFIX" ]; then
      source-if-exists "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
    fi
  }
fi
