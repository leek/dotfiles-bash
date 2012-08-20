#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mCompletion Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

_cap() {
    local cache_file=".cache_cap_t"
    local cur=${COMP_WORDS[COMP_CWORD]}
    case $cur in
        -*  )
            COMPREPLY=($(compgen -W '-d --debug -e --explain -F --default-config -f --file -H --long-help -h --help -l --logger -n --dry-run -p --password -q --quiet -r --preserve-roles -S --set-before -s --set -T --tasks -t --tool -v --verbose -V --version -X --skip-system-config -x --skip-user-config --' -- $cur))
            ;;
        *   )
            if [ ! -e "$cache_file" ]; then
                cap -T | awk '/^cap / {print $2}' > $cache_file
            fi
            declare -a tasks=$(cat $cache_file)
            COMPREPLY=($(compgen -W "${tasks}" -- $cur))
            ;;
    esac
}

complete -o default -o nospace -F _cap cap
