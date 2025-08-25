#
# VSCode environment setup.
#

if [[ $TERM_PROGRAM == "vscode" ]]; then
  bindkey -e

  # Fix alt+left/right inserting `;3D` and `;3C` instead of word navigation.
  bindkey '\e[1;3D' backward-word   # Alt+Left
  bindkey '\e[1;3C' forward-word    # Alt+Right
fi
