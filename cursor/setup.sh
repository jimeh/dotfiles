#! /usr/bin/env bash

# ==============================================================================
# Settings
# ==============================================================================

# List of config files to symlink from current directory.
CONFIG_SOURCES=(
  "settings.json"
  "keybindings.json"
  "snippets"
)

# Detect current script directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==============================================================================
# Help
# ==============================================================================

show_help() {
  cat <<EOF
Usage: $(basename "$0") COMMAND

Commands:
  config, conf             Create symlinks for Cursor config files
  dump-extensions, dump    Export installed Cursor extensions to extensions.txt
  extensions, ext          Install Cursor extensions from extensions.txt

Description:
  This script manages Cursor editor configuration files and extensions.
  It can create symlinks for settings, keybindings, and snippets,
  as well as backup and restore extensions.
EOF
}

# ==============================================================================
# Functions
# ==============================================================================

# Determine Cursor config directory.
cursor_config_dir() {
  case "$(uname -s)" in
  "Darwin")
    echo "${HOME}/Library/Application Support/Cursor/User"
    ;;
  "Linux")
    echo "${HOME}/.config/Cursor/User"
    ;;
  *)
    echo "Error: Unsupported operating system"
    exit 1
    ;;
  esac
}

# Backup and symlink
backup_and_link() {
  local source="$1"
  local target="$2"
  local real_target
  local real_source

  # Check if target already exists
  if [[ -e "${target}" ]]; then
    # If it's a symlink, check if it points to the same location
    if [[ -L "${target}" ]]; then
      real_target="$(readlink -f "${target}")"
      real_source="$(readlink -f "${source}")"
      if [[ "${real_target}" == "${real_source}" ]]; then
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

# Create symlinks
do_symlink() {
  # Create Cursor config directory if it doesn't exist
  local config_dir
  config_dir="$(cursor_config_dir)"

  mkdir -p "${config_dir}"
  for path in "${CONFIG_SOURCES[@]}"; do
    backup_and_link "${SCRIPT_DIR}/${path}" "${config_dir}/${path}"
  done

  echo "Symlink setup complete!"
}

# Find the cursor CLI command
find_cursor_cmd() {
  local cursor_cmd=""

  # Check for cursor CLI in multiple possible locations
  for cmd in "cursor" "/Applications/Cursor.app/Contents/Resources/app/bin/cursor" "${HOME}/Applications/Cursor.app/Contents/Resources/app/bin/cursor"; do
    if command -v "${cmd}" >/dev/null 2>&1; then
      cursor_cmd="${cmd}"
      break
    fi
  done

  if [[ -z "${cursor_cmd}" ]]; then
    echo "Error: cursor command not found" >&2
    exit 1
  fi

  echo "${cursor_cmd}"
}

# Dump installed extensions to extensions.txt
do_dump_extensions() {
  local cursor_cmd
  cursor_cmd="$(find_cursor_cmd)"
  local extensions_file="${SCRIPT_DIR}/extensions.txt"
  local current_date
  current_date="$(date)"

  {
    echo "# Cursor Extensions"
    echo "# Generated on ${current_date}"
    echo
    "${cursor_cmd}" --list-extensions
  } >"${extensions_file}"

  echo "Extensions list dumped to ${extensions_file}"
}

# Install extensions from extensions.txt
do_install_extensions() {
  local cursor_cmd
  cursor_cmd="$(find_cursor_cmd)"
  local extensions_file="${SCRIPT_DIR}/extensions.txt"

  if [[ ! -f "${extensions_file}" ]]; then
    echo "Error: ${extensions_file} not found"
    exit 1
  fi

  # Read extensions file, skip comments and empty lines
  while IFS= read -r line; do
    if [[ -n "${line}" && ! "${line}" =~ ^[[:space:]]*# ]]; then
      echo "Installing extension: ${line}"
      "${cursor_cmd}" --install-extension "${line}"
    fi
  done <"${extensions_file}"

  echo "Extensions installation complete!"
}

# ==============================================================================
# Main
# ==============================================================================

main() {
  case "${1:-}" in
  "config" | "conf")
    do_symlink
    ;;
  "dump-extensions" | "dump")
    do_dump_extensions
    ;;
  "extensions" | "ext")
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
}

# Run main function.
main "$@"
