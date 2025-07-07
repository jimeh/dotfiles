#
# zshrc helper functions
#
# Helpers designed for use during setup of interactive shell environments in
# `~/.zshrc`.
#

# Helper function to set up shell completions for a given command. It generates
# Zsh completion scripts and places them in the specified completions directory.
# If the completion file already exists, it checks if the source file has been
# updated and regenerates the completions if necessary.
#
# Arguments:
#
#   $1 - cmd:         The name of the command for which completions are being
#                     set up.
#   $2 - source:      The source file used to determine if completions need to
#                     be re-generated. For example, the binary file of the
#                     command (e.g., rustup).
#   $@ - args:        The command to run to generate the completions. This
#                     should produce Zsh completion scripts.
#
# Example usage:
#
#     setup-completions rustup "$(command -v rustup)" rustup completions zsh
#
# This example sets up completions for the 'rustup' command by running
# 'rustup completions zsh', and places the generated completion script in the
# appropriate completions directory. If the source file is newer than the target
# completion file, the command is re-executed and the completion script is
# updated.
#
# The completions are placed in the directory specified by the ZSH_COMPLETIONS
# environment variable. If ZSH_COMPLETIONS is not set, the completions are
# placed in `$HOME/.zsh/completions` by default.
setup-completions() {
  local cmd="$1"
  local source="$2"
  shift 2
  local script="$@"

  local target_dir="${ZSH_COMPLETIONS:-$HOME/.zsh/completions}"
  local target_file="${target_dir}/_${cmd}"

  if [[ -z "$cmd" || -z "$source" || -z "$script" ]]; then
    echo "setup-completions: Missing required arguments." >&2
    return 1
  fi

  if [[ -z "$(command-path "$cmd")" ]]; then
    echo "setup-completions: Command not found: $cmd" >&2
    return 1
  fi

  if [[ -z "$source" ]]; then
    echo "setup-completions: Source file not found: $source" >&2
    return 1
  fi

  # Check if the target completion file needs to be updated
  if [[ ! -f "$target_file" || "$source" -nt "$target_file" ]]; then
    echo "setup-completions: Setting up completion for $cmd: $script" >&2
    mkdir -p "$target_dir"
    eval "$script" >| "$target_file"
    chmod +x "$target_file"

    # Only run compinit if not already loaded
    if ! (whence -w compinit &> /dev/null); then
      autoload -U compinit && compinit
    fi
  fi
}

# Convert a bash/zsh alias to a function. It prints the `unalias` command and the
# function definition, meaning the output needs to be evaluated to take effect.
#
# Arguments:

#   $1: The alias to convert. Should be a single line like "alias ll='ls -alF'"
#       or "ll='ls -alF'".
#
# Example:
#
#     alias brew="op plugin run -- brew"
#     convert_alias_to_function "$(alias brew)"
#
# This will print:
#
#     unalias brew
#     brew() {
#       op plugin run -- brew "$@"
#     }
#
convert-alias-source-to-function-source() {
  local line="$1"

  # Remove Bash's "alias " prefix if present.
  line=${line#alias }

  # Extract the alias name and the raw command.
  local alias_name="$(echo "$line" | cut -d'=' -f1)"
  local raw_command="$(echo "$line" | cut -d'=' -f2)"

  # Evaluate the raw command to ensure we get the correct command, with any
  # quotes or shell escape characters handled correctly.
  local command
  eval "command=$raw_command"

  # Abort if the command is empty.
  if [ -z "$command" ]; then
    echo "Error: Empty command for alias $alias_name" >&2
    return 1
  fi

  # Print the `unalias` command and the function definition.
  echo -e "unalias ${alias_name}"
  echo -e "${alias_name}() {\n  ${command} \"\$@\"\n}"
}

# Convert a bash/zsh alias to a function. It replaces the alias with a function
# definition in the current shell that has the same behavior as the alias.
#
# Arguments:
#   $1: The alias to convert. Should be the name of the alias.
#
# Example:
#
#     alias brew="op plugin run -- brew"
#     convert-alias-to-function brew
#
# This will replace the alias "brew" with a function that has the same behavior.
convert-alias-to-function() {
  local alias_name="$1"

  # Get the alias source.
  local alias_source="$(alias "$alias_name")"

  # Abort if the alias does not exist.
  if [ -z "$alias_source" ]; then
    echo "Error: Alias $alias_name does not exist" >&2
    return 1
  fi

  eval "$(convert-alias-source-to-function-source "$alias_source")"
}
