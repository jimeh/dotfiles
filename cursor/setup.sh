#! /usr/bin/env bash

# ==============================================================================
# Settings
# ==============================================================================

# Default editor to configure (cursor, vscode, or vscode-insiders)
SETUP_EDITOR="cursor"

# List of config files to symlink from current directory.
CONFIG_SOURCES=(
  "settings.json"
  "keybindings.json"
  "snippets"
)

# Detect current script directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get extensions lockfile path for current editor
get_extensions_lock() {
  echo "${SCRIPT_DIR}/extensions.${SETUP_EDITOR}.lock"
}

# ==============================================================================
# Help
# ==============================================================================

show_help() {
  cat << EOF
Usage: $(basename "$0") EDITOR COMMAND

Editors:
  cursor                  Cursor editor
  vscode, vsc             Visual Studio Code
  vscode-insiders, vsci   Visual Studio Code Insiders

Commands:
  config, conf           Create symlinks for editor config files
  dump-extensions, dump  Export installed editor extensions to extensions.txt
  extensions, ext        Install editor extensions from extensions.txt

Description:
  This script manages editor configuration files and extensions.
  It can create symlinks for settings, keybindings, and snippets,
  as well as backup and restore extensions.
EOF
}

# ==============================================================================
# Functions
# ==============================================================================

# Determine editor config directory
editor_config_dir() {
  case "$(uname -s)" in
    "Darwin")
      case "${SETUP_EDITOR}" in
        "cursor")
          echo "${HOME}/Library/Application Support/Cursor/User"
          ;;
        "vscode")
          echo "${HOME}/Library/Application Support/Code/User"
          ;;
        "vscode-insiders")
          echo "${HOME}/Library/Application Support/Code - Insiders/User"
          ;;
        *)
          echo "Error: Invalid editor '${SETUP_EDITOR}' for macOS"
          exit 1
          ;;
      esac
      ;;
    "Linux")
      case "${SETUP_EDITOR}" in
        "cursor")
          echo "${HOME}/.config/Cursor/User"
          ;;
        "vscode")
          echo "${HOME}/.config/Code/User"
          ;;
        "vscode-insiders")
          echo "${HOME}/.config/Code - Insiders/User"
          ;;
        *)
          echo "Error: Invalid editor '${SETUP_EDITOR}' for Linux"
          exit 1
          ;;
      esac
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
  # Create editor config directory if it doesn't exist
  local config_dir
  config_dir="$(editor_config_dir)"

  mkdir -p "${config_dir}"
  for path in "${CONFIG_SOURCES[@]}"; do
    backup_and_link "${SCRIPT_DIR}/${path}" "${config_dir}/${path}"
  done

  echo "Symlink setup complete!"
}

# Find the editor CLI command
find_editor_cmd() {
  local editor_cmd=""

  case "${SETUP_EDITOR}" in
    "cursor")
      # Check for cursor CLI in multiple possible locations
      for cmd in "cursor" "/Applications/Cursor.app/Contents/Resources/app/bin/cursor" "${HOME}/Applications/Cursor.app/Contents/Resources/app/bin/cursor"; do
        if command -v "${cmd}" > /dev/null 2>&1; then
          editor_cmd="${cmd}"
          break
        fi
      done
      ;;
    "vscode")
      # Check for VSCode CLI in multiple possible locations
      for cmd in "code" "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"; do
        if command -v "${cmd}" > /dev/null 2>&1; then
          editor_cmd="${cmd}"
          break
        fi
      done
      ;;
    "vscode-insiders")
      # Check for VSCode Insiders CLI in multiple possible locations
      for cmd in "code-insiders" "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code" "${HOME}/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code"; do
        if command -v "${cmd}" > /dev/null 2>&1; then
          editor_cmd="${cmd}"
          break
        fi
      done
      ;;
    *)
      echo "Error: Invalid editor '${SETUP_EDITOR}'"
      exit 1
      ;;
  esac

  if [[ -z "${editor_cmd}" ]]; then
    echo "Error: ${SETUP_EDITOR} command not found" >&2
    exit 1
  fi

  echo "${editor_cmd}"
}

# Dump installed extensions to extensions.lock
do_dump_extensions() {
  local editor_cmd
  editor_cmd="$(find_editor_cmd)"
  local current_date
  current_date="$(date)"
  local extensions_lock
  extensions_lock="$(get_extensions_lock)"

  {
    echo "# ${SETUP_EDITOR} Extensions"
    echo "# Generated on ${current_date}"
    echo
    "${editor_cmd}" --list-extensions --show-versions
  } > "${extensions_lock}"

  echo "Extensions list dumped to ${extensions_lock}"
}

# Global variable to cache installed extensions
_INSTALLED_EXTENSIONS=""

# Check if extension is already installed, ignoring version
is_extension_installed() {
  local editor_cmd="$1"
  local extension="$2"

  # Build cache if not already built
  if [[ -z "${_INSTALLED_EXTENSIONS}" ]]; then
    _INSTALLED_EXTENSIONS="$("${editor_cmd}" --list-extensions --show-versions)"
  fi

  # Check if extension exists in cached list
  echo "${_INSTALLED_EXTENSIONS}" | grep -q "^${extension}@"
}

# Install extensions from extensions.lock
do_install_extensions() {
  local editor_cmd
  editor_cmd="$(find_editor_cmd)"
  local extensions_cache_dir="${SCRIPT_DIR}/cache/extensions"
  local extensions_lock
  extensions_lock="$(get_extensions_lock)"

  if [[ ! -f "${extensions_lock}" ]]; then
    echo "Error: ${extensions_lock} not found"
    exit 1
  fi

  # Process each extension
  while IFS= read -r line; do
    if [[ -n "${line}" && ! "${line}" =~ ^[[:space:]]*# ]]; then
      extension="${line%@*}"
      version="${line#*@}"

      # Check if already installed with correct version
      if is_extension_installed "${editor_cmd}" "${extension}"; then
        echo "Extension ${extension} is already installed, skipping"
        continue
      fi

      # For VSCode and VSCode Insiders we can install directly from the marketplace
      if [[ "${SETUP_EDITOR}" == "vscode" || "${SETUP_EDITOR}" == "vscode-insiders" ]]; then
        echo "Installing ${extension}@${version}"
        if ! "${editor_cmd}" --install-extension "${extension}@${version}"; then
          echo "Warning: Failed to install ${extension}@${version}"
        fi
        continue
      fi

      # For Cursor we need to download and install from .vsix file
      local vsix_path="${extensions_cache_dir}/${extension}@${version}.vsix"

      # Create extensions directory if it doesn't exist
      mkdir -p "${extensions_cache_dir}"

      # If .vsix doesn't exist, download it
      if [[ ! -f "${vsix_path}" ]]; then
        local publisher_id="${extension%%.*}"
        local extension_id="${extension#*.}"
        local vsix_url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher_id}/vsextensions/${extension_id}/${version}/vspackage"

        echo "Downloading ${extension}@${version}.vsix..."
        echo "  - URL: ${vsix_url}"
        if ! curl --compressed -L -o "${vsix_path}" "${vsix_url}"; then
          echo "Warning: Failed to download ${extension}@${version}.vsix"
          continue
        fi
      fi

      # Install the extension from .vsix file
      echo "Installing extension from ${vsix_path}"
      if ! "${editor_cmd}" --install-extension "${vsix_path}"; then
        echo "Warning: Failed to install ${extension}@${version}"
      fi

      # Clean up the .vsix file after installation attempt
      rm "${vsix_path}"
    fi
  done < "${extensions_lock}"

  # Clean up extensions directory if empty
  rmdir "${extensions_cache_dir}" 2> /dev/null || true
  echo "Extensions installation complete!"
}

# ==============================================================================
# Main
# ==============================================================================

main() {
  if [[ $# -lt 1 ]]; then
    echo "Error: No editor specified"
    show_help
    exit 1
  fi

  if [[ $# -lt 2 ]]; then
    echo "Error: No command specified"
    show_help
    exit 1
  fi

  # Set editor from first argument
  editor="$(echo "${1}" | tr '[:upper:]' '[:lower:]')"
  case "${editor}" in
    "vscode" | "code" | "vsc" | "v")
      SETUP_EDITOR="vscode"
      ;;
    "vscode-insiders" | "code-insiders" | "insiders" | "vsci" | "i")
      SETUP_EDITOR="vscode-insiders"
      ;;
    "cursor" | "c")
      SETUP_EDITOR="cursor"
      ;;
    *)
      echo "Error: Unsupported editor '${editor}'"
      echo "Supported editors: cursor, vscode (vsc), vscode-insiders (vsci)"
      exit 1
      ;;
  esac

  # Get command from second argument
  local command="${2}"

  # Handle commands
  case "${command}" in
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
      echo "Error: Unknown command '${command}'"
      show_help
      exit 1
      ;;
  esac
}

# Run main function.
main "$@"
