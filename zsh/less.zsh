#
# less setup
#

alias le="less"

# Enable syntax highlighting via source-highlight
if command-exists "src-hilite-lesspipe.sh"; then
  export LESSOPEN="| src-hilite-lesspipe.sh %s"
  export LESS=" -R "
elif [ -f "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]; then
  export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
  export LESS=" -R "
fi
