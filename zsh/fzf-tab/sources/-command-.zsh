# :fzf-tab:complete:(-command-:|command:option-(v|V)-rest)
case $group in
  'external command'|'alias')
    which $word
    ;;
  'executable file')
    which ${realpath#--*=}
    ;;
  'builtin command'|'reserved word')
    run-help $word | bat -lman
    ;;
  parameter)
    echo ${(P)word}
    ;;
esac
