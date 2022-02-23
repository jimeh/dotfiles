#
# fzf
#

export FZF_DEFAULT_OPTS="--bind=ctrl-k:kill-line --border=none --tabstop=4"
export FZF_TMUX_HEIGHT=100%
export FZF_TMUX=0
export FZF_CTRL_T_OPTS="--preview='less {}'"

# Install fzf binary from latest GitHub Release.
zinit ice wait lucid from'gh-r' as'program' pick'fzf'
zinit light junegunn/fzf

# Install fzf-tmux command and zsh plugins from default branch on GitHub.
zinit ice wait lucid from'gh' as'program' pick'bin/fzf-tmux' \
  multisrc'shell/{completion,key-bindings}.zsh' \
  id-as'junegunn/fzf-extras'
zinit light junegunn/fzf
