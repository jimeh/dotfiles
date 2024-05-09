#
# tldr Setup
#

if command-exists tldr && [ -f "$HOME/.config/tlrc/config.toml" ]; then
  alias tldr='tldr --config $HOME/.config/tlrc/config.toml'
fi
