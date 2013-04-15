#
# Bash Prompt
#

# Setup and use git-aware-prompt
if [ -f "$DOTBASH/git-aware-prompt/main.sh" ]; then
  GITAWAREPROMPT="$DOTBASH/git-aware-prompt"
  source "$GITAWAREPROMPT/main.sh"
  export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
  export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
else
  # Customize prompt to act like pre-leopard
  PS1='\h:\w \u$ '
fi
