# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

typeset -Ag FX FG BG

FX=(
    reset     "[00m"
    bold      "[01m" no-bold      "[22m"
    italic    "[03m" no-italic    "[23m"
    underline "[04m" no-underline "[24m"
    blink     "[05m" no-blink     "[25m"
    reverse   "[07m" no-reverse   "[27m"
)

for color in {000..255}; do
    FG[$color]="[38;5;${color}m"
    BG[$color]="[48;5;${color}m"
done


#
# Powerline-Arrow theme
#

PROMPT='%n@%m %{$FG[000]%}%{$BG[235]%}⮀%{$reset_color%}%{$BG[235]%} %~ $(check_git_prompt_info)%{$reset_color%} $ '

local return_code="%(?..%{$fg[cyan]%}%? ↵%{$reset_color%})"
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[236]%}%{$BG[237]%}⮀ %{$FG[014]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$FG[238]%}⮀%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[001]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" "


# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string. -- Brorrowed from Soliah.zsh-theme :)
function check_git_prompt_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if [[ -z $(git_prompt_info) ]]; then
      echo "%{$fg[cyan]%}(detached%{$fg[magenta]%}*%{$fg[cyan]%})%{$reset_color%}"
    else
      echo "$(git_prompt_info)"
    fi
  else
    echo "%{$reset_color%}%{$FG[236]%}⮀"
  fi
}
