#
# 1Password CLI integration
#

# Load 1Password CLI plugins if available.
if [ -f "$HOME/.config/op/plugins.sh" ]; then
  source "$HOME/.config/op/plugins.sh"
fi
