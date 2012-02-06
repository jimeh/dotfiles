#
# PATH Helpers
#
# A few useful functions to manipulate the PATH environment variable. Use,
# modify, copy, steal, plunder these functions to your hearts content, at
# your own risk of course :) --jimeh
#


# Print PATH as a newline separated list.
#
# Example:
#
#   $ echo $PATH
#   /usr/bin:/usr/local/bin
#   $ path_list
#   /usr/bin
#   /usr/local/bin
#
path_list () {
    echo -e ${PATH//:/\\n}
}

# Append specified path to the end of PATH.
#
# Takes one argument:
#  - $1: path to add
#
# If $1 already exists it is first removed, and then added to the end of PATH.
#
# Example:
#
#   $ echo $PATH
#   /usr/bin:/usr/local/bin
#   $ path_append "/usr/sbin"
#   $ echo $PATH
#   /usr/bin:/usr/local/bin:/usr/sbin
#
path_append () {
    if [ ! -n "$1" ]; then return 2; fi
    path_remove $1
    export PATH="$PATH:$1"
}

# Prepend specified path to the begnning of PATH.
#
# Takes one argument:
#  - $1: path to add
#
# If $1 already exists it is first removed, and then added to the beginning of
# PATH.
#
# Example:
#
#   $ echo $PATH
#   /usr/bin:/usr/local/bin
#   $ path_prepend "/usr/sbin"
#   $ echo $PATH
#   /usr/sbin:/usr/bin:/usr/local/bin
#
path_prepend () {
    if [ ! -n "$1" ]; then return 2; fi
    path_remove $1
    export PATH="$1:$PATH"
}

# Remove specified path from PATH.
#
# Takes one argument:
#  - $1: path to remove
#
# Example:
#
#   $ echo $PATH
#   /usr/bin:/usr/local/bin
#   $ path_remove "/usr/local/bin"
#   $ echo $PATH
#   /usr/bin
#
path_remove () {
    if [ ! -n "$1" ]; then return 2; fi
    if [[ ":$PATH:" == *":$1:"* ]]; then
        local dirs=":$PATH:"
        dirs=${dirs/:$1:/:}
        export PATH="$(__path_clean $dirs)"
        return 0
    fi
    return 1
}

# Add a path to PATH before another path.
#
# Takes two arguments:
#  - $1: path to add
#  - $2: target path to add $1 before
#
# If $1 already exists in PATH it is first removed, and then added before $2.
#
# Example:
#
#   $ echo $PATH
#   /usr/bin:/usr/local/bin
#   $ path_add_before "/usr/local/sbin" "/usr/local/bin"
#   $ echo $PATH
#   /usr/bin:/usr/local/sbin:/usr/local/bin
#
path_add_before () {
    if [ ! -n "$1" ] || [ ! -n "$2" ]; then return 2; fi
    if [[ ":$PATH:" == *":$2:"* ]]; then
        path_remove $1
        local dirs=":$PATH:"
        dirs=${dirs/:$2:/:$1:$2:}
        export PATH="$(__path_clean $dirs)"
        return 0
    fi
    return 1
}

# Add a path to PATH after another path.
#
# Takes two arguments:
#  - $1: path to add
#  - $2: target path to add $1 after
#
# If $1 already exists in PATH it is first removed, and then added after $2.
#
# Example:
#
#   $ echo $PATH
#   /usr/bin:/usr/local/bin
#   $ path_add_after "/usr/local/sbin" "/usr/local/bin"
#   $ echo $PATH
#   /usr/bin:/usr/local/bin:/usr/local/sbin
#
path_add_after () {
    if [ ! -n "$1" ] || [ ! -n "$2" ]; then return 2; fi
    if [[ ":$PATH:" == *":$2:"* ]]; then
        path_remove $1
        local dirs=":$PATH:"
        dirs=${dirs/:$2:/:$2:$1:}
        export PATH="$(__path_clean $dirs)"
        return 0
    fi
    return 1
}

# Strips first and last character from intput string.
#
# Example:
#   __path_clean ":/bin:/usr/bin:" #=> /bin:/usr/bin
#
__path_clean () {
    local dirs=${1%?}
    echo ${dirs#?}
}
