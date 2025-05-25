#
# 1Password CLI integration
#

# Setup 1Password CLI shell plugin integration using functions instead of
# aliases. This is necessary for shell completion to work correctly with aliases
# to commands which have 1Password integration enabled.
#
# This function is a hacky-ish workaround to the issue described here:
# https://github.com/1Password/shell-plugins/issues/433
#
# It loads the 1Password CLI plugin script file, then finds all aliases that are
# 1Password shell plugin aliases and converts them to functions. The functions
# are then stored in a cache file, which is sourced every time the shell is
# started.
#
# The cache file is only updated if the plugins script file is newer than the
# cache file. This is to prevent the cache file from being updated every time
# the shell is started.
#
# To use this function, simply call it once during shell startup, and it will
# take care of the rest.
#
# Arguments:
#   $1: The script file containing the 1Password CLI plugin aliases. Default is
#       $HOME/.config/op/plugins.sh.
#   $2: The cache file to store the converted functions. Default is
#       $HOME/.config/op/plugins_as_functions.cache.sh.
setup_op_shell_plugins_using_functions() {
  local script_file="${1:-$HOME/.config/op/plugins.sh}"
  local cache_file="${2:-$HOME/.config/op/plugins_as_functions.cache.sh}"

  # Silently return if the script file doesn't exist.
  if [ ! -f "$script_file" ]; then
    return
  fi

  # Source the script file.
  source "$script_file"

  # If cache file exists, and is newer than the plugin script file, just source
  # the cache file and return.
  if [ -f "$cache_file" ] && [ "$script_file" -ot "$cache_file" ]; then
    source "$cache_file"
    return
  fi

  # Get all aliases that use "op plugin run --".
  local aliases="$(alias | grep 'op plugin run --')"

  # If no aliases are found, just clear the cache file and return.
  if [ -z "$aliases" ]; then
    echo -n "" > "$cache_file"
    return
  fi

  # Loop through each alias, convert it to a function, and store it in the cache
  # file.
  local command
  local alias_name
  local raw_command
  while IFS= read -r line; do
    # Remove Bash's "alias " prefix if present.
    line="${line#alias }"

    # Extract the alias name and the raw command.
    alias_name="$(echo "$line" | cut -d'=' -f1)"
    raw_command="$(echo "$line" | cut -d'=' -f2)"

    # Evaluate the raw command to ensure we get the correct command, with any
    # quotes or shell escape characters handled correctly.
    eval "command=$raw_command"

    # Skip if command is empty or does not start with "op plugin run --".
    if [ -z "$command" ] || [[ "$command" != "op plugin run --"* ]]; then
      continue
    fi

    # Print the unalias command and the function definition.
    echo -e "unalias ${alias_name}"
    echo -e "${alias_name}() {\n  ${command} \"\$@\"\n}"
  done <<< "$aliases" > "$cache_file"

  source "$cache_file"
}

# Setup 1Password CLI shell plugin integration with custom function that makes
# it play nicer with shell completion.
setup_op_shell_plugins_using_functions
