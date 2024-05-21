#
# Z-Shell Init
#

# In our zshenv file we have on macOS disabled loading ZSH startup files from
# /etc to avoid /etc/zprofile messing up our carefully constructed PATH. So we
# need to manually load the other files we care about.
if [[ "$OSTYPE" == "darwin"* ]] && [ -f "/etc/zshrc" ]; then
  source "/etc/zshrc"
fi

# ==============================================================================
# Zinit
# ==============================================================================

declare -A ZINIT
ZINIT[HOME_DIR]="$HOME/.local/zsh/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/bin"

# Load zinit module if it exists. For more info, run: zinit module help
if [ -d "${ZINIT[HOME_DIR]}/module/Src/zdharma_continuum" ]; then
  module_path+=("${ZINIT[HOME_DIR]}/module/Src")
  zmodload zdharma_continuum/zinit
fi

# Ask to clone Zinit if it's not already available on disk.
[ ! -d "${ZINIT[BIN_DIR]}" ] &&
  read -q "REPLY?Zinit not installed, clone to ${ZINIT[BIN_DIR]}? [y/N]:" &&
  echo &&
  git clone --depth=1 "https://github.com/zdharma-continuum/zinit.git" "${ZINIT[BIN_DIR]}"

# Load Zinit
source "${ZINIT[BIN_DIR]}/zinit.zsh"

# Add generic cross platform  clipcopy and clippaste commands to copy and paste
# from the system clipboard.
zinit for @OMZ::lib/clipboard.zsh

# ==============================================================================
# History
# ==============================================================================

# Set various sane defaults for ZSH history management.
zinit for @OMZ::lib/history.zsh

# Map history search to ctrl-p and ctrl-n.
# bindkey '^p' history-beginning-search-backward
# bindkey '^n' history-beginning-search-forward

## History file configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=50000

## History command configuration
setopt append_history          # append history to HISTFILE
setopt extended_history        # record timestamp of command in HISTFILE
setopt hist_expire_dups_first  # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_find_no_dups       # do not display a duplicate history entry
setopt hist_ignore_dups        # ignore duplicated commands history list
setopt hist_ignore_space       # ignore commands that start with space
setopt hist_reduce_blanks      # remove superfluous blanks before adding to history
setopt hist_verify             # show command with history expansion to user before running it
setopt inc_append_history_time # add timestamp to HISTFILE in order of execution
setopt share_history           # share command history data

# ==============================================================================
# Completion
# ==============================================================================

if [ -d "$ZSH_COMPLETIONS" ]; then fpath=("$ZSH_COMPLETIONS" $fpath); fi
if [ -d "$DOTZSH_SITEFUNS" ]; then fpath=("$DOTZSH_SITEFUNS" $fpath); fi
if [ -d "$BREW_SITEFUNS" ]; then fpath=("$BREW_SITEFUNS" $fpath); fi

# Enable interactive selection of completions.
zinit for @OMZ::lib/completion.zsh

# Install fzf-tab if fzf is available.
if command-exists fzf; then
  # TODO: Switch back to upstream Aloxaf/fzf-tab when this PR is merged:
  # - https://github.com/Aloxaf/fzf-tab/pull/445
  zinit light-mode wait lucid atclone'git checkout fit-preview' \
    for @jimeh/fzf-tab

  zinit light-mode lucid for @Freed-Wu/fzf-tab-source
  # Disable some overly aggressive completions from fzf-tab-source.
  zstyle -d ':fzf-tab:complete:*' fzf-preview
fi

zinit light-mode wait lucid blockf for @zsh-users/zsh-completions

zinit light-mode wait lucid atload"!_zsh_autosuggest_start" \
  for @zsh-users/zsh-autosuggestions

# Map ctrl+x h to show completion context info.
bindkey '^Xh' _complete_help

# Group completions by type under group headings
zstyle ':completion:*' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-grouped true
zstyle ':autocomplete:*' groups 'always'

# Case-insensitive completion.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

# git
zstyle ':completion:*:*:git:*:branches' group-name 'local branches'
zstyle ':completion:*:*:git:*:remote-branches' group-name 'remote branches'
zstyle ':completion:*:*:git:*:tags' group-name 'tags'
zstyle ':completion:*:git-checkout:*' sort false

# Improve selection of Makefile completions - from:
# https://github.com/zsh-users/zsh-completions/issues/541#issuecomment-384223016
zstyle ':completion:*:make:*:targets' call-command true

autoload -Uz compinit
compinit

# Setup fzf related stuff if it is available.
if command-exists fzf; then
  export FZF_DEFAULT_OPTS="
         --bind=ctrl-k:kill-line
         --bind=ctrl-v:half-page-down
         --bind=alt-v:half-page-up
         --tabstop=4
         --highlight-line"

  export FZF_CTRL_T_OPTS="
         --walker-skip .git,node_modules,.terraform,target
         --bind 'ctrl-/:change-preview-window(down|hidden|)'"

  # TODO: replace pbcopy with something that's cross-platform.
  export FZF_CTRL_R_OPTS="
         --border=rounded
         --preview 'echo {}' --preview-window up:3:hidden:wrap
         --bind 'ctrl-/:toggle-preview'
         --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"

  export FZF_ALT_C_OPTS="
         --walker-skip .git,node_modules,.terraform,target
         --preview 'tree -C {}'"

  export FZF_TMUX=1
  export FZF_TMUX_OPTS="-p 75%"
  export FZF_TMUX_HEIGHT=""

  cached-eval "$(command -v fzf)" fzf --zsh

  zstyle ':completion:*' menu no
  zstyle ':completion:*' special-dirs true

  zstyle ':fzf-tab:*' fzf-bindings \
    'ctrl-v:half-page-down' \
    'alt-v:half-page-up' \
    'ctrl-k:kill-line'
  zstyle ':fzf-tab:*' fzf-flags '\
    --highlight-line' \
    '--tabstop=4'
  zstyle ':fzf-tab:*' prefix ''
  zstyle ':fzf-tab:*' switch-group '<' '>'

  # Use fzf-tab's tmux popup for tab completion.
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  zstyle ':fzf-tab:*' popup-min-size 30 10
  zstyle ':fzf-tab:*' popup-pad 0 0
  zstyle ':fzf-tab:*' popup-fit-preview yes

  if command-exists eza; then
    fzf_dir_preview='eza -1 --color=always --icons $realpath'
    zstyle ':fzf-tab:complete:eza:*' fzf-preview "$fzf_dir_preview"
  else
    fzf_dir_preview='ls -1 --color=always $realpath'
  fi
  zstyle ':fzf-tab:complete:cd:*' fzf-preview "$fzf_dir_preview"
  zstyle ':fzf-tab:complete:ls:*' fzf-preview "$fzf_dir_preview"

  if command-exists bat; then
    fzf_bat_preview='bat --color=always -n -r :500'
    FZF_CTRL_T_OPTS="$FZF_CTRL_T_OPTS --preview '$fzf_bat_preview {}'"
    zstyle ':fzf-tab:complete:bat:*' fzf-preview "$fzf_bat_preview \$realpath"
    zstyle ':fzf-tab:complete:cat:*' fzf-preview "$fzf_bat_preview \$realpath"
  else
    FZF_CTRL_T_OPTS="$FZF_CTRL_T_OPTS --preview 'less {}'"
  fi
fi

# ==============================================================================
# Visuals
# ==============================================================================

zinit light-mode wait lucid \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  for @zdharma-continuum/fast-syntax-highlighting

# ==============================================================================
# Edit command line
# ==============================================================================

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# ==============================================================================
# Helper Functions
# ==============================================================================

source "$DOTZSH/zshrc.funcs.zsh"

# ==============================================================================
# Private Dotfiles
# ==============================================================================

if [ -f "$DOTPFILES/zshrc" ]; then
  source "$DOTPFILES/zshrc"
fi

# ==============================================================================
# Environment and Tool Managers
# ==============================================================================

# If available, make sure to load direnv shell hook before mise.
if command-exists direnv; then
  cached-eval "$(command -v direnv)" direnv hook zsh
fi

MISE_HOME="$HOME/.local/share/mise"
MISE_ZSH_INIT="$MISE_HOME/shell/init.zsh"
export MISE_INSTALL_PATH="$MISE_HOME/bin/mise"

if ! command-exists mise; then
  read -q 'REPLY?mise is not installed, install with `curl https://mise.run | sh`? [y/N]:' &&
    echo && curl https://mise.run | sh
fi

if command-exists mise; then
  alias mi="mise"

  setup-completions mise "$MISE_INSTALL_PATH" mise completions zsh
  cached-eval "$MISE_INSTALL_PATH" mise activate zsh
fi

# ==============================================================================
# Prompt
# ==============================================================================

if ! command-exists starship && [ -f "$MISE_INSTALL_PATH" ]; then
  read -q 'REPLY?starship is not installed, install with `mise install starship`? [y/N]:' &&
    echo && "$MISE_INSTALL_PATH" install starship
fi

if command-exists starship; then
  setup-completions starship "$(command -v starship)" starship completions zsh
  cached-eval "$(command -v starship)" starship init zsh --print-full-init
else
  echo "WARN: starship not found, skipping prompt setup" >&2
  echo "      install with: mise install starship" >&2

fi

# ==============================================================================
# Tool specific setup
# ==============================================================================

# Aliases
source "$DOTZSH/aliases.zsh"

# OS specific
if [[ "$OSTYPE" == "darwin"* ]]; then source "$DOTZSH/macos.zsh"; fi
if [[ "$OSTYPE" == "linux"* ]]; then source "$DOTZSH/linux.zsh"; fi

# Utils
source "$DOTZSH/1password.zsh"
source "$DOTZSH/copilot.zsh"
source "$DOTZSH/emacs.zsh"
source "$DOTZSH/less.zsh"
source "$DOTZSH/mise.zsh"
source "$DOTZSH/neovim.zsh"
source "$DOTZSH/nix.zsh"
source "$DOTZSH/tldr.zsh"
source "$DOTZSH/tmux.zsh"
source "$DOTZSH/zoxide.zsh"

# Development
source "$DOTZSH/containers.zsh"
source "$DOTZSH/git.zsh"
source "$DOTZSH/golang.zsh"
source "$DOTZSH/google-cloud.zsh"
source "$DOTZSH/kubernetes.zsh"
source "$DOTZSH/nodejs.zsh"
source "$DOTZSH/python.zsh"
source "$DOTZSH/ruby.zsh"
source "$DOTZSH/rust.zsh"
source "$DOTZSH/scaleway.zsh"

# ==============================================================================
# Basic Z-Shell settings
# ==============================================================================

# Disable auto-title.
DISABLE_AUTO_TITLE="true"

# Disable shared history.
unsetopt share_history

# Disable attempted correction of commands (is wrong 98% of the time).
unsetopt correctall

# ==============================================================================
# Local Overrides
# ==============================================================================

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

autoload -U +X bashcompinit && bashcompinit
