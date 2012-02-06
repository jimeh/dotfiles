# Aliases
alias svnadderall="svn status | grep '^?' | cut -b 8- | xargs svn add"
alias svnridallin="svn status | grep '^!' | cut -b 8- | xargs svn remove --keep-local"
