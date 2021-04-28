#
# Docker Related
#

if command-exists docker; then
  zinit ice from'gh-r' as'program' mv'ctop-* -> ctop'
  zinit light bcicen/ctop
fi

docker_remove_exited() {
  docker rm $(docker ps -f='status=exited' -q)
}

alias d="docker"
alias dc="docker compose"
alias co="docker compose"
alias dre="docker_remove_exited"
