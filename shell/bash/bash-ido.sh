## bash-ido  - attempt to simulate a interactive menu similar to
#             ido-mode in emacs
#
# URL: http://pgas.freeshell.org/shell/bash-ido

# Author: <pierre.gaston@gmail.com>
# Version: 1.0beta2
# CVS: $Id: bash-ido,v 1.18 2010/02/13 14:50:32 pgas Exp $

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with BASH-IDO; see the file COPYING.  If not, write to the
# Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301, USA.
#

# Documentation:
# --------------

# This is a fairly complex completion script for cd. (For now, i tried
# to make the functions a bit generic so that the menu can be used for
# other completions. Let me know if you need some help or something)
# It mimics what ido-mode does in emacs.This script also masks the
# normal cd with a function to track the list of the directory
# used. It's easier to try than to describe, here is a little getting
# started:
#
# 0) Source this script in your .bashrc (. /path/to/bash-ido)
# 1) Start your cd command, press TAB, type some letters the list of dirs is 
#    filtered according to these letters.
# 2) Press RET to select the first dir in the list.
# 3) DEL ie the erase key (usually backspace or ^H), to delete a search letter.
#    When there are no more letters, pressing DEL let you go up one dir.
# 4) C-s or <right> cycles the list to the right, C-r or <left> to the left
# 5) C-g or C-c cancels the completion.
# 6) Typing 2 / will put you in /, typing /~/ will put you in $HOME
# 7) up/M-s and down/M-r allows to navigate in the history
 
# Limitations
# -----------
# * You cannot start completion after a dirname in " " or ' '
#   (actually it's probably possible if you modify COMP_WORDBREAKS)
# * It doesn't expand the ~user/ dirs, if you need this please tell me
# * The completion disables and re-enables C-c using stty, 
#   if you use another char for  intr you need to modify 
#   the hard coded value (search for $'\003') this could be found  via stty
#   or a parameter could be defined but how well....tell me if you feel this
#   is needed.
# * It probably doesn't work too well with huge dirs (a security check could
#   perhaps be implemented).

#  Implementation Notes:
#  ---------------------
# * Not sure what bash version is required.
# * It Probably doesn't work too well with some strange filenames.
# * All the functions and variables in this file should be prefixed by _ido_
#   to avoid namespace polution
# * Use stty rather than a trap to disable sigint....I couldn't do what 
#   I wanted with trap.
# * I choose to use the hardcoded ansi codes rather than tput, it should be 
#   a tad faster and reduce the dependencies, if you it doesn't work in your
#   terminal please tell me.

#  TODO:
#  -----
#  * add an example for other completions
#  * support for CDPATH in dir completion?
#  * implement persitent history?
#  * complete on ~ first and handle ~user?

# Global vars
# -----------
# _ido_menu               -- the list of choices
# _ido_f_menu             -- the filtered menu
# _ido_search_string      -- the characters typed so far
# _ido_result             -- the dirname part of the search
  _ido_history_size=100 # -- maximum dir entries in the history
# _ido_history            -- list of the directories in the history
# _ido_history_point      -- pointer to the current history entry

# Functions
# ---------
# _ido_print_menu -- print the filtered menu
# _ido_loop       -- the main keyboard event loop
# _ido_filter     -- filters the menu 
# _ido_gen_dir    -- generate the original menu (list of dirs)
# _ido_dir        -- entry point

# Changes
# -------
# 1.0b2
# * fix ../ behaviour 
# * fix TAB behaviour 

shopt -s checkwinsize #so that COLUMNS stays up to date

_ido_print_f_menu () {
    # Prints the directories limited on one line...
    # We would need some terminal commands to clear more than one line
    local prompt menu i cur
    prompt=${_ido_result}${_ido_search_string}    
    if (( ${#_ido_f_menu[@]} ));then
	menu="{ ${_ido_f_menu[0]#* }"
	i=1
	while cur=${_ido_f_menu[i]#* };
	      ((  i < (${#_ido_f_menu[@]} -1) 
		  && (${#menu}+${#prompt} +${#cur}+11) < COLUMNS )) \
	      || ((  i == (${#_ido_f_menu[@]} -1)
		  && (${#menu}+${#prompt}+${#cur}+4) < COLUMNS)); do
	    menu+=" | ${cur}"
	    i=$((i+1))
	done
	if  ((i < (${#_ido_f_menu[@]} -1) )) ; then
	    menu+=" | ... }"
	else
	    menu+=" }"
	fi
	#yet another hack to put the cursor after the search string.
	printf "\r%*s\r%*s%s\r%s" $COLUMNS " " ${#prompt} " " "$menu" "$prompt"
    else
	printf "\r%*s\r%*s%s\r%s" $COLUMNS " " ${#prompt} " " "[ No Match]" "$prompt"
    fi
}

_ido_filter () {
    local i start trans_i cas quoted
    if shopt -q nocasematch;then
	cas=set
    else
	shopt -s nocasematch
    fi
    start=${_ido_f_menu[i]%% *}
    unset _ido_f_menu
    if [[ "$_ido_search_string" ]];then
	printf -v quoted "%q" "$_ido_search_string"
    else
	quoted=""
    fi
    for i in "${!_ido_menu[@]}";do
	trans_i=$(((i+start)%${#_ido_menu[@]}))
	if [[ "${_ido_menu[trans_i]}" = *"$quoted"* ]];then
	    _ido_f_menu+=( "$trans_i ${_ido_menu[trans_i]}" )
	fi
    done
    if [[ -z $cas ]];then
	shopt -u nocasematch
    fi
}

_ido_loop () {
    local  REPLY c
    while :;do
	_ido_print_f_menu >&2
	unset c
	while :;do
	    #loop to read the escape sequences
	    IFS= read -d '' -r -s -n 1
	    case $REPLY in
		$'\E') 
		    c+=$REPLY
		    ;;
		\[|O)
		    c+=$REPLY
		    if ((${#c} ==1));then
			break
		    fi
		    ;;
		*)
		    c+=$REPLY
		    break
		    ;;
	    esac
	done
	case $c in 
	    $'\n'|$'\t') # RET
		_ido_result="${_ido_result}${_ido_f_menu[0]#* }"
		return 0
		;;
	    / ) # /
		case $_ido_search_string in
		    ..)
			_ido_result+="../"
			;;
		    \~)
			_ido_result="$HOME/"
			;;
		    ?*)
			_ido_result="${_ido_result}${_ido_f_menu[0]#* }"
			;;
		    *)
			_ido_result=/
			;;
		esac
		return 0
		;;
	    '$\b'|$'\177') #DEL aka ^? or ^h 
		if [[ $_ido_search_string ]]; then 
		    _ido_search_string=${_ido_search_string%?}
		    _ido_filter
		else		    
		    _ido_result+="../"
		    return 0
		fi
		;;
	    $'\a' | $'\003') # C-g | C-c
		return 2
		;;
	    $'\E[C'|$'\EOC'|$'\023') #<right> | C-s
		if ((${#_ido_f_menu[@]}>1));then 
		    _ido_f_menu=("${_ido_f_menu[@]:1}"  "${_ido_f_menu[0]}")
		fi
		;;
	    $'\E[D'|$'\EOD'|$'\022') #<left> | C-r 
		if ((${#_ido_f_menu[@]}>1));then 
		    _ido_f_menu=("${_ido_f_menu[${#_ido_f_menu[@]}-1]}"  
		                     "${_ido_f_menu[@]:0:${#_ido_f_menu[@]}-1}")
		fi
		;;
	    $'\E[B'|$'\EOB'|$'\367'|$'\Er') # <down> | M-r
		if ((_ido_history_point>1));then
		    _ido_history_point=$((_ido_history_point-1))
		    _ido_result=${_ido_history[_ido_history_point]%/}/
		    _ido_search_string=""
		    return 0
		else
		    printf "\a" >&2
		fi
		;;
	    $'\E[A'|$'\EOA'|$'\362'|$'\Es') # <up> | M-s
		if (((_ido_history_point+1)< ${#_ido_history[@]}));then
		    _ido_history_point=$((_ido_history_point+1))
		    _ido_result=${_ido_history[_ido_history_point]%/}/
		    _ido_search_string=""
		    return 0
		else
		    printf "\a" >&2
		fi
		;;
	    [[:print:]])
		_ido_search_string+=$REPLY
		_ido_filter
		;;
	    *)
		printf "\a" >&2
#		printf "%q\n" "$c"
	    ;;
        esac	
    done
}

_ido_gen_dir () {
    # return a list of subdir in _ido_result,
    local pattern
    case $_ido_search_string in 
	..)
	    pattern=../
	    ;;
	.)
	    pattern="./ ..?*/ .[!.]*/ */"
	    ;;
	.?*)
	    pattern="..?*/ .[!.]*/ */"
	    ;;
	*)
	    pattern="./ */ ..?*/ .[!.]*/"
	    ;;
    esac
    _ido_result=${_ido_result/#~\//$HOME/}
    unset _ido_menu
    IFS=$'\n' read -r -d '' -a _ido_menu \
	< <(IFS=" ";shopt -s nullglob;\
              eval command cd "$_ido_result" 2>/dev/null \
	      && printf -- "%q\n" $pattern)
    if [[ $_ido_search_string ]];then
	_ido_filter
    else
	local i e
	unset _ido_f_menu
	for e in "${_ido_menu[@]}";do
	    _ido_f_menu[i]="$i $e"
	    i=$((i+1))
	done
    fi
    _ido_result="${_ido_result/#$HOME\//~/}"
}

_ido_dir () {
    _ido_result=${COMP_WORDS[COMP_CWORD]}

    if [[ "$_ido_result" == \$* ]]; then
	if [[ "$_ido_result" == */* ]];then
	    local temp
	    temp=${_ido_result%%/*}
	    temp=${temp#?}
	    _ido_result=${!temp}/${_ido_result#*/}
	else
	    COMPREPLY=( $( compgen -v -P '$' -- "${_ido_result#$}" ) )
	    return 0
	fi
    fi
    stty intr undef
    local status 
    unset _ido_f_menu _ido_search_string _ido_history_point
    printf '\E7' #tput sc = save cursor
    status=0
    case $_ido_result in
	''|.|./ ) 
	    _ido_result=$PWD/
	    ;;
	*/*)
	    _ido_search_string=${_ido_result##*/}
	    _ido_result=${_ido_result%/*}/
	    _ido_result=${_ido_result/#~\//$HOME/}
	    if [[ ! -d ${_ido_result} ]]; then
		printf "\a\nNo Such Directory: %s\n" "${_ido_result}" >&2
		status=1
	    fi
	    ;;
	 *)
	    _ido_search_string=$_ido_result
	    _ido_result=$PWD/	   
	    ;;
    esac
    # normalize ie remove the // and other foo/../bar
    _ido_result=$(command cd "$_ido_result" && printf "%q" "${PWD%/}/")
    while [[ $status = 0 && $_ido_result != */./ ]]; do
	# hmm this part is dir specific...TB generalized..
	case $_ido_result in
	    # order is important, the last case covers the first ones
	    /../)
		_ido_result=/
		;;
	    \~/../) 
		_ido_result=${HOME%/*}/
		;;
	    */../)
		_ido_result=${_ido_result%/*/../}/
		;;
	esac
	_ido_gen_dir
	_ido_loop; status=$?
	_ido_search_string=""
	
    done
    printf "\r%*s\E8" $COLUMNS # clear the line, tput rc restore the cursor
    kill -WINCH $$    # force bash to redraw
    stty intr $'\003'
    if [[ $status = 0 ]]; then
	# gives the _ido_result to bash
	COMPREPLY[0]=${_ido_result%./}
    fi 
    return $status
}

complete -F _ido_dir -o nospace cd

cd () {
   if command cd "$@";then
       _ido_history=($(printf "%s\n" "$PWD" "${_ido_history[@]}" |\
             	awk -v s="$_ido_history_size" '!a[$0]++;(i++==s-1){exit}'))
   fi
}
###  Local Variables:
###  mode: shell-script
###  End:
