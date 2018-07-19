#
# TMPDIR setup
#

# Ensure TMPDIR is the same for local and remote ssh logins
if [[ $TMPDIR == "/var/folders/"* ]] || [[ $TMPDIR == "" ]]; then
  export TMPDIR="/tmp/user-$USER"
  mkdir -p "$TMPDIR"
fi
