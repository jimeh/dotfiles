#
# ctags
#

# *nix systems.
if [ -d "/opt/universal-ctags/bin" ]; then
  path_prepend "/opt/universal-ctags/bin"
fi

if [ -d "/opt/global-ctags/bin" ]; then
  path_prepend "/opt/global-ctags/bin"
fi
