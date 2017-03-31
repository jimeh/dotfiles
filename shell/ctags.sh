#
# ctags
#

# *nix systems.
if [ -d "/opt/universal-ctags/bin" ]; then
  path_append "/opt/universal-ctags/bin"
fi

if [ -d "/opt/global-ctags/bin" ]; then
  path_append "/opt/global-ctags/bin"
fi
