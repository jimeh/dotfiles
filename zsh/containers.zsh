#
# Containers
#

# Docker
if command-exists docker; then
  zinit light-mode wait lucid from'gh-r' as'program' mv'ctop-* -> ctop' \
    for @bcicen/ctop
fi

docker_remove_exited() {
  docker rm $(docker ps -f='status=exited' -q)
}

# Disable docker scan suggestion/advertisement. It currently prints even when -q
# is passed to docker build.
export DOCKER_SCAN_SUGGEST=false

alias d="docker"
alias dc="docker compose"
alias co="docker-compose"
alias dre="docker_remove_exited"

alias n="nerdctl"
alias ne="nerdctl"
alias nec="nerdctl compose"

# Podman
alias p="podman"
alias pd="podman"
alias pm="podman machine"
alias pc="podman-compose"
