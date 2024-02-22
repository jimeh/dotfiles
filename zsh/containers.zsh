#
# Containers
#

if command-exists docker; then
  docker_remove_exited() {
    docker rm $(docker ps -f='status=exited' -q)
  }

  # Disable docker scan suggestion/advertisement. It currently prints even when
  # -q is passed to docker build.
  export DOCKER_SCAN_SUGGEST=false

  alias d="docker"
  alias dc="docker compose"
  alias co="docker-compose"
  alias dre="docker_remove_exited"
fi

if command-exists nerdctl; then
  alias n="nerdctl"
  alias ne="nerdctl"
  alias nec="nerdctl compose"
fi

if command-exists podman; then
  alias p="podman"
  alias pd="podman"
  alias pm="podman machine"
  alias pc="podman-compose"
fi

if command-exists orb; then
  alias oc="orb"
  setup-completions orb "$(command -v orb)" orb completion zsh
fi
