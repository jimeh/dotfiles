#
# Google Cloud SDK setup.
#

if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
fi

# Lazy load gcloud shell completion on first use.
if command-exists gcloud; then
  _python_argcomplete() {
    load-gcloud-completion
    _python_argcomplete "$@"
  }

  compctl -K _python_argcomplete gcloud

  load-gcloud-completion() {
    unset -f load-gcloud-completion _python_argcomplete
    if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then
      source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
    fi
  }
fi
