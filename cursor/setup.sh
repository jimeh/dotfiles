#! /usr/bin/env bash

# Define source directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_CURSOR_CONFIG_DIR=""
# Determine OS and set config directory
cursor_config_dir() {
  if [[ -n "${_CURSOR_CONFIG_DIR}" ]]; then
    echo "${_CURSOR_CONFIG_DIR}"
    return
  fi

  case "$(uname -s)" in
  "Darwin")
    _CURSOR_CONFIG_DIR="${HOME}/Library/Application Support/Cursor/User"
    ;;
  "Linux")
    _CURSOR_CONFIG_DIR="${HOME}/.config/Cursor/User"
    ;;
  *)
    echo "Error: Unsupported operating system"
    exit 1
    ;;
  esac

  echo "${_CURSOR_CONFIG_DIR}"
}

# Function to backup and symlink
backup_and_link() {
  local source="$1"
  local target="$2"

  # Check if target already exists
  if [[ -e "${target}" ]]; then
    # If it's a symlink, check if it points to the same location
    if [[ -L "${target}" ]]; then
      local current_target
      current_target="$(readlink "${target}")"
      if [[ "${current_target}" == "${source}" ]]; then
        echo "Skipping ${target} - already linked to ${source}"
        return
      fi
    fi

    echo "Backing up existing ${target} to ${target}.bak"
    mv "${target}" "${target}.bak"
  fi

  # Create symlink
  echo "Creating symlink for ${source} to ${target}"
  ln -s "${source}" "${target}"
}

# Function to create symlinks
do_symlink() {
  # Create Cursor config directory if it doesn't exist
  local config_dir
  config_dir="$(cursor_config_dir)"

  mkdir -p "${config_dir}"

  # Backup and symlink settings.json
  backup_and_link "${SCRIPT_DIR}/settings.json" "${config_dir}/settings.json"

  # Backup and symlink keybindings.json
  backup_and_link "${SCRIPT_DIR}/keybindings.json" "${config_dir}/keybindings.json"

  # Backup and symlink snippets directory
  backup_and_link "${SCRIPT_DIR}/snippets" "${config_dir}/snippets"

  echo "Symlink setup complete!"
}

# Replace do_dump_extensions function:
do_dump_extensions() {
  if ! command -v cursor >/dev/null 2>&1; then
    echo "Error: cursor command not found"
    exit 1
  fi

  local extensions_file="${SCRIPT_DIR}/extensions.txt"
  local current_date
  current_date="$(date)"
  {
    echo "# Cursor Extensions"
    echo "# Generated on ${current_date}"
    echo
    cursor --list-extensions
  } >"${extensions_file}"

  echo "Extensions list dumped to ${extensions_file}"
}

# Function to install extensions
do_install_extensions() {
  local extensions_file="${SCRIPT_DIR}/extensions.txt"

  if [[ ! -f "${extensions_file}" ]]; then
    echo "Error: ${extensions_file} not found"
    exit 1
  fi

  # Read extensions file, skip comments and empty lines
  while IFS= read -r line; do
    if [[ -n "${line}" && ! "${line}" =~ ^# ]]; then
      echo "Installing extension: ${line}"
      cursor --install-extension "${line}"
    fi
  done <"${extensions_file}"

  echo "Extensions installation complete!"
}

# Help message function
show_help() {
  echo "Available commands: symlink (or link), dump-extensions, install-extensions"
}

# Main command handler
case "${1:-}" in
"symlink" | "link")
  do_symlink
  ;;
"dump-extensions" | "dump")
  do_dump_extensions
  ;;
"install-extensions" | "install")
  do_install_extensions
  ;;
"")
  echo "Error: No command provided"
  show_help
  exit 1
  ;;
*)
  echo "Error: Unknown command '$1'"
  show_help
  exit 1
  ;;
esac
