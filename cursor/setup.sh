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

# Extensions lockfile path
EXTENSIONS_LOCK="${SCRIPT_DIR}/extensions.lock"

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

# Dump installed extensions to extensions.lock
do_dump_extensions() {
  local cursor_cmd
  cursor_cmd="$(find_cursor_cmd)"
  local current_date
  current_date="$(date)"

  {
    echo "# Cursor Extensions"
    echo "# Generated on ${current_date}"
    echo
    "${cursor_cmd}" --list-extensions --show-versions
  } >"${EXTENSIONS_LOCK}"

  echo "Extensions list dumped to ${EXTENSIONS_LOCK}"
}

# Global variable to cache installed extensions
_INSTALLED_EXTENSIONS=""

# Check if extension is already installed with exact version
is_extension_installed() {
  local cursor_cmd="$1"
  local extension="$2"
  local version="$3"

  # Build cache if not already built
  if [[ -z "${_INSTALLED_EXTENSIONS}" ]]; then
    _INSTALLED_EXTENSIONS="$("${cursor_cmd}" --list-extensions --show-versions)"
  fi

  # Check if extension@version exists in cached list
  echo "${_INSTALLED_EXTENSIONS}" | grep -q "^${extension}@${version}$"
}

# Download and install a single extension.
#
# This is needed for cursor right now as installing an extension based on its
# ID yields a signature error. But installing from a .vsix file works fine.
download_and_install_extension() {
  local cursor_cmd="$1"
  local extension="$2"
  local version="$3"
  local extensions_dir="$4"

  # Check if already installed with correct version
  if is_extension_installed "${cursor_cmd}" "${extension}" "${version}"; then
    echo "Extension ${extension}@${version} is already installed, skipping"
    return 0
  fi

  local vsix_path="${extensions_dir}/${extension}@${version}.vsix"

  # Create extensions directory if it doesn't exist
  mkdir -p "${extensions_dir}"

  # If .vsix doesn't exist, download it
  if [[ ! -f "${vsix_path}" ]]; then
    local publisher_id="${extension%%.*}"
    local extension_id="${extension#*.}"
    local vsix_url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher_id}/vsextensions/${extension_id}/${version}/vspackage"

    echo "Downloading ${extension}@${version}.vsix..."
    echo "  - URL: ${vsix_url}"
    if ! curl --compressed -L -o "${vsix_path}" "${vsix_url}"; then
      echo "Failed to download ${extension}@${version}.vsix"
      return 1
    fi
  fi

  # Install the extension from .vsix file
  echo "Installing extension from ${vsix_path}"
  if ! "${cursor_cmd}" --install-extension "${vsix_path}"; then
    echo "Failed to install ${extension}@${version}"
    return 1
  fi

  # Clean up the .vsix file after successful installation
  rm "${vsix_path}"
  return 0
}

# Install extensions from extensions.lock
do_install_extensions() {
  local cursor_cmd
  cursor_cmd="$(find_cursor_cmd)"
  local extensions_dir="${SCRIPT_DIR}/cache/extensions"

  if [[ ! -f "${EXTENSIONS_LOCK}" ]]; then
    echo "Error: ${EXTENSIONS_LOCK} not found"
    exit 1
  fi

  # Process each extension
  while IFS= read -r line; do
    if [[ -n "${line}" && ! "${line}" =~ ^[[:space:]]*# ]]; then
      extension="${line%@*}"
      version="${line#*@}"

      if ! download_and_install_extension "${cursor_cmd}" "${extension}" "${version}" "${extensions_dir}"; then
        echo "Warning: Failed to install ${extension}@${version}"
      fi
    fi
  done <"${EXTENSIONS_LOCK}"

  # Clean up extensions directory if empty
  rmdir "${extensions_dir}" 2>/dev/null || true
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
