#
# atuin
#

if command-exists atuin; then
  # Atuin + FZF integration, stolen/adapted from:
  # - https://github.com/atuinsh/atuin/issues/68
  atuin-setup() {
    export ATUIN_NOBIND="true"
    eval "$(atuin init zsh)"

    zle -N fzf-atuin-history-widget
    bindkey '^R' fzf-atuin-history-widget
  }

  fzf-atuin-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

    # local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
    local atuin_opts="--cmd-only"
    local fzf_opts=(
      # from $FZF_DEFAULT_OPTS
      --bind=ctrl-k:kill-line
      --bind=ctrl-v:half-page-down
      --bind=alt-v:half-page-up
      --tabstop=4
      --highlight-line

      # from $FZF_CTRL_R_OPTS
      --tmux=75%
      --border=rounded
      "--preview=echo {}"
      --preview-window=down:3:hidden:wrap
      "--bind=ctrl-/:toggle-preview"
      "--bind=ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort"

      --tac
      "-n2..,.."
      --tiebreak=index
      "--query=${LBUFFER}"
      "+m"
      "--bind=ctrl-r:reload(atuin search $atuin_opts)"
    )

    selected=$(atuin search ${atuin_opts} | fzf "${fzf_opts[@]}")
    local ret=$?
    if [ -n "$selected" ]; then
      # the += lets it insert at current pos instead of replacing
      LBUFFER+="${selected}"
    fi

    zle reset-prompt
    return $ret
  }

  atuin-setup
  setup-completions atuin "$(mise-which atuin)" atuin gen-completions --shell zsh
fi
