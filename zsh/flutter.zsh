#
# Flutter environment setup
#

if [ -d "/opt/flutter/bin" ]; then
  path_append "/opt/flutter/bin"
  alias fl="flutter"

  if [ -d "/opt/flutter/bin/cache/dart-sdk/bin" ]; then
    path_append "/opt/flutter/bin/cache/dart-sdk/bin"
  fi
fi
