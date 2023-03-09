#
# fzf
#

export FZF_CTRL_T_OPTS="--preview='less {}'"
export FZF_DEFAULT_OPTS="--bind=ctrl-k:kill-line --border=none --tabstop=4"
export FZF_TMUX=0
export FZF_TMUX_HEIGHT=100%

# Install fzf binary from latest GitHub Release.
zinit light-mode wait lucid from'gh-r' as'program' pick'fzf' \
  for @junegunn/fzf

# Install fzf-tmux command and zsh plugins from default branch on GitHub.
zinit light-mode wait lucid from'gh' as'program' pick'bin/fzf-tmux' \
  multisrc'shell/{completion,key-bindings}.zsh' \
  id-as'junegunn/fzf-extras' \
  for @junegunn/fzf
