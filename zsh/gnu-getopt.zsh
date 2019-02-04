#
# Use gnu-getopt if it's available
#

if [ -f "/usr/local/opt/gnu-getopt/bin/getopt" ]; then
  path_prepend "/usr/local/opt/gnu-getopt/bin"
fi
