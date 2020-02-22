#
# Docker Related
#

alias d="docker"
alias dc="docker-compose"
alias co="docker-compose"

docker_remove_exited () {
  docker rm "$(docker ps -f='status=exited' -q)"
}
