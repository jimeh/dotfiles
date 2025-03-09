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
Usage: $(basename "$0") EDITOR COMMAND [OPTIONS]

Editors:
  cursor, c                   Cursor editor
  vscode, code, vsc, v        Visual Studio Code
  vscode-insiders, vsci, i    Visual Studio Code Insiders
  windsurf, surf, w           Windsurf editor

Commands:
  config, conf             Create symlinks for editor config files
  dump-extensions, dump    Export installed editor extensions to extensions.txt
  extensions, ext          Install editor extensions from extensions.txt

Options:
  --latest                 When used with extensions command, installs the
                           latest version of each extension instead of the
                           exact version from the lock file

Description:
  This script manages editor configuration files and extensions.
  It can create symlinks for settings, keybindings, and snippets,
  as well as dump extension lock files and install extensions from them.
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
        "windsurf")
          echo "${HOME}/Library/Application Support/Windsurf/User"
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
        "windsurf")
          echo "${HOME}/.config/Windsurf/User"
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
  local possible_commands=()

  case "${SETUP_EDITOR}" in
    "cursor")
      # Set possible Cursor CLI command locations
      possible_commands=(
        "cursor"
        "/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
        "${HOME}/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
      )
      ;;
    "vscode")
      # Set possible VSCode CLI command locations
      possible_commands=(
        "code"
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        "${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
      )
      ;;
    "vscode-insiders")
      # Set possible VSCode Insiders CLI command locations
      possible_commands=(
        "code-insiders"
        "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code"
        "${HOME}/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code"
      )
      ;;
    "windsurf")
      # Set possible Windsurf CLI command locations
      possible_commands=(
        "windsurf"
        "/Applications/Windsurf.app/Contents/Resources/app/bin/windsurf"
        "${HOME}/Applications/Windsurf.app/Contents/Resources/app/bin/windsurf"
      )
      ;;
    *)
      echo "Error: Invalid editor '${SETUP_EDITOR}'"
      exit 1
      ;;
  esac

  # Check for the command in all possible locations
  for cmd in "${possible_commands[@]}"; do
    echo "Checking ${cmd}" >&2
    if command -v "${cmd}" > /dev/null 2>&1; then
      editor_cmd="${cmd}"
      break
    fi
  done

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

# Install an extension directly using the marketplace
install_extension_direct() {
  local editor_cmd="$1"
  local extension="$2"
  local version="$3"
  local use_latest="$4"
  local result=0

  if [[ "${use_latest}" == "true" ]]; then
    echo "Installing ${extension} (latest version)"
    if ! "${editor_cmd}" --install-extension "${extension}"; then
      echo "Warning: Direct install failed for ${extension}"
      result=1
    fi
  else
    echo "Installing ${extension}@${version}"
    if ! "${editor_cmd}" --install-extension "${extension}@${version}"; then
      echo "Warning: Direct install failed for ${extension}@${version}"
      result=1
    fi
  fi

  return ${result}
}

# Install an extension via downloading .vsix file
install_extension_via_vsix() {
  local editor_cmd="$1"
  local extension="$2"
  local version="$3"
  local use_latest="$4"
  local extensions_cache_dir="$5"
  local result=0

  local publisher_id="${extension%%.*}"
  local extension_id="${extension#*.}"
  local vsix_path=""
  local vsix_url=""
  local install_version=""

  if [[ "${use_latest}" == "true" ]]; then
    # In latest mode, we need to first query the marketplace to get the latest version
    echo "Finding latest version for ${extension}..."

    # Query the VS Marketplace API to get the extension metadata
    local metadata_url="https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"
    local temp_metadata="${extensions_cache_dir}/metadata-${extension}.json"

    # Create extensions directory if it doesn't exist
    mkdir -p "${extensions_cache_dir}"

    # Create a JSON request payload to query for the extension details
    local request_data='{
      "filters": [
        {
          "criteria": [
            { "filterType": 7, "value": "'${extension}'" }
          ]
        }
      ],
      "flags": 2
    }'

    # Query the marketplace for extension metadata
    if ! curl --silent --compressed -X POST -H "Content-Type: application/json" -H "Accept: application/json; api-version=7.2-preview.1" -d "${request_data}" "${metadata_url}" > "${temp_metadata}"; then
      echo "Warning: Failed to query metadata for ${extension}"
      rm -f "${temp_metadata}"
      return 1
    fi

    # Extract the latest version from the response
    if command -v jq > /dev/null 2>&1; then
      # If jq is available, use it to parse JSON
      install_version=$(jq -r '.results[0].extensions[0].versions[0].version' "${temp_metadata}" 2> /dev/null)
    else
      # Fallback to grep/sed for basic extraction if jq is not available
      install_version=$(grep -o '"version":"[^"]*"' "${temp_metadata}" | head -1 | sed 's/"version":"//;s/"//' 2> /dev/null)
    fi

    # Clean up metadata file
    rm -f "${temp_metadata}"

    # If we couldn't extract a version, use original version as fallback
    if [[ -z "${install_version}" || "${install_version}" == "null" ]]; then
      echo "Warning: Could not determine latest version, falling back to lock file version"
      install_version="${version}"
    else
      echo "Latest version of ${extension} is ${install_version}"
    fi

    # Set up the download path and URL for the specific version we found
    vsix_path="${extensions_cache_dir}/${extension}@${install_version}.vsix"
    vsix_url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher_id}/vsextensions/${extension_id}/${install_version}/vspackage"
  else
    # In strict mode, use the exact version from the lock file
    echo "Installing ${extension}@${version} via .vsix"
    vsix_path="${extensions_cache_dir}/${extension}@${version}.vsix"
    vsix_url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher_id}/vsextensions/${extension_id}/${version}/vspackage"
    install_version="${version}"
  fi

  # Create extensions directory if it doesn't exist
  mkdir -p "${extensions_cache_dir}"

  # Download the .vsix file
  echo "Downloading ${extension}@${install_version}.vsix..."
  echo "  - URL: ${vsix_url}"
  if ! curl --compressed -L -o "${vsix_path}" "${vsix_url}"; then
    echo "Warning: Failed to download ${extension}@${install_version}.vsix"
    rm -f "${vsix_path}" # Clean up potential partial downloads
    return 1
  fi

  # Install the extension from .vsix file
  echo "Installing extension from ${vsix_path}"
  if ! "${editor_cmd}" --install-extension "${vsix_path}"; then
    echo "Warning: Failed to install ${extension}@${install_version} from .vsix"
    result=1
  fi

  # Clean up the .vsix file after installation attempt
  rm -f "${vsix_path}"

  return ${result}
}

# Install extensions from extensions.lock
do_install_extensions() {
  local editor_cmd
  editor_cmd="$(find_editor_cmd)"
  local extensions_cache_dir="${SCRIPT_DIR}/cache/extensions"
  local extensions_lock
  extensions_lock="$(get_extensions_lock)"
  local use_latest="${1:-false}"

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

      # For Cursor we need to download and install from .vsix file, as
      # installation via ID fails with a signature verification error.
      if [[ "${SETUP_EDITOR}" == "cursor" ]]; then
        install_extension_via_vsix "${editor_cmd}" "${extension}" "${version}" "${use_latest}" "${extensions_cache_dir}"
        continue
      fi

      if ! install_extension_direct "${editor_cmd}" "${extension}" "${version}" "${use_latest}"; then
        echo "Direct installation failed, trying .vsix download method..."
        install_extension_via_vsix "${editor_cmd}" "${extension}" "${version}" "${use_latest}" "${extensions_cache_dir}"
      fi
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
    "windsurf" | "wind" | "surf" | "w")
      SETUP_EDITOR="windsurf"
      ;;
    *)
      echo "Error: Unsupported editor '${editor}'"
      echo "Supported editors: cursor, vscode (vsc), vscode-insiders (vsci), windsurf (wind)"
      exit 1
      ;;
  esac

  # Get command from second argument
  local command="${2}"
  shift 2

  # Default values for options
  local use_latest="false"

  # Parse additional options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --latest)
        use_latest="true"
        shift
        ;;
      *)
        echo "Error: Unknown option '$1'"
        show_help
        exit 1
        ;;
    esac
  done

  # Handle commands
  case "${command}" in
    "config" | "conf")
      do_symlink
      ;;
    "dump-extensions" | "dump")
      do_dump_extensions
      ;;
    "extensions" | "ext")
      do_install_extensions "${use_latest}"
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
