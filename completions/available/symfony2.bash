#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mCompletion Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

export COMP_WORDBREAKS=${COMP_WORDBREAKS//:}

_console() {
    local cache_file=".cache_console"
    local cur=${COMP_WORDS[COMP_CWORD]}
    case $cur in
        -*  )
            COMPREPLY=($(compgen -W '-h --help -q --quiet -v --verbose -V --version --ansi --no-ansi -n --no-interaction -s --shell --process-isolation -e --env --no-debug --' -- $cur))
            ;;
        *   )
            if [ ! -e "$cache_file" ]; then
                app/console list | awk '/^  / {print $1}' | sed '/^--/d' > $cache_file
            fi
            declare -a commands=$(cat $cache_file)
            COMPREPLY=($(compgen -W "${commands}" -- $cur))
            ;;
    esac
}

complete -o default -o nospace -F _console console
