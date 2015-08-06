#
# dokku
#

if [ -e "$HOME/.dokku/contrib/dokku_client.sh" ]; then
  alias dokku="$HOME/.dokku/contrib/dokku_client.sh"
  alias do="dokku"
fi
