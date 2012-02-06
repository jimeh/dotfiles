#
# Bash Prompt
#

PROMPT_COMMAND="find_git_branch; $PROMPT_COMMAND"

# Git enabled prompt
export PS1="\[$txtrst\]\u@\h \w\[$txtcyn\]\$git_branch\[$txtrst\]\$ "
export SUDO_PS1="\[$txtrst\]\[$bakred\]\u@\h\[$txtrst\] \w\$ "

# Customize prompt to act like pre-leopard
# PS1='\h:\w \u$ '
