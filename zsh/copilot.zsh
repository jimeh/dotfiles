#
# Setup for GitHub Copilot CLI
#

# Lazy-load the Copilot CLI helpers on first use.
if command-exists github-copilot-cli; then
  setup_copilot-cli-integration() {
    local cmd="$1"
    shift

    eval "$(github-copilot-cli alias -- "$SHELL")"

    "$cmd" "$@"
  }

  copilot_what-the-shell() {
    setup_copilot-cli-integration "$0" "$@"
  }
  alias '??'='copilot_what-the-shell'
  alias 'wts'='copilot_what-the-shell'

  copilot_git-assist() {
    setup_copilot-cli-integration "$0" "$@"
  }
  alias 'git?'='copilot_git-assist'

  copilot_gh-assist() {
    setup_copilot-cli-integration "$0" "$@"
  }
  alias 'gh?'='copilot_gh-assist'
fi
