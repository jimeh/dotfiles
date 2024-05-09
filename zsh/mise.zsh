#
# mise extra setup
#

if command-exists mise; then
  # Wrap a tool with "mise exec" if the tool is managed by mise. Primarily this
  # ensures that the tool is run with correct environment variables set with
  # mise.
  #
  # Specifically it allows calling a tool prefixed with `MISE_ENV=<name>`, and
  # have the relevant environment variables from the relevant
  # `.mise.<name>.toml` files loaded.
  mise-wrap-tool() {
    local executable="$1"
    local tool="${2:-$executable}"

    eval "${executable}() {
      if mise current \"${tool}\" > /dev/null; then
        mise exec \"${tool}\" -- \"${executable}\" \"\$@\"
      else
        command \"${executable}\" \"\$@\"
      fi
    }"
  }

  mise-wrap-tool terraform
fi
