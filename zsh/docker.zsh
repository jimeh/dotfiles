#
# Docker Related
#

alias d="docker"
alias dc="docker-compose"
alias co="docker-compose"

docker_remove_exited() {
  docker rm "$(docker ps -f='status=exited' -q)"
}

if command-exists docker; then
  zinit ice from'gh-r' as'program' mv'ctop-* -> ctop'
  zinit light bcicen/ctop
fi
