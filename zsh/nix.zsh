#
# Nix interative setup
#

sort_nix_paths() {
  local nix_paths=()

  for p in "${(@)path}"; do
    if [[ "$p" == "/nix/store/"* ]]; then
      nix_paths+=("$p")
    fi
  done

  for p in "${(@)nix_paths}"; do
    path_prepend "$p"
  done
}

if command-exists nix-shell; then
  sort_nix_paths
fi
