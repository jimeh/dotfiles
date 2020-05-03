#
# Docker Related
#

alias d="docker"
alias dc="docker-compose"
alias co="docker-compose"

if ! (( $+commands[ctop] )); then
  ctop() {
    docker run --rm -ti --name=ctop-$RANDOM \
           --volume /var/run/docker.sock:/var/run/docker.sock:ro \
           quay.io/vektorlab/ctop:latest
  }
fi

docker_remove_exited () {
  docker rm "$(docker ps -f='status=exited' -q)"
}
