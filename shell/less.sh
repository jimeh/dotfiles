#
# less setup
#

alias le="less"

# Enable syntax highlighting via source-highlight
if command -v src-hilite-lesspipe.sh > /dev/null; then
  export LESSOPEN="| src-hilite-lesspipe.sh %s"
  export LESS=" -R "
fi
