#
# Linux specific setup
#

# Ensure 256 color support in Linux
if [[ "$(uname)" == "Linux" ]]; then
  export TERM="xterm-256color"
fi
