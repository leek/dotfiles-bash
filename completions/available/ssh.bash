#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mCompletion Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

_sshcomplete() {
    if [ -r $HOME/.ssh/config ]; then
        COMPREPLY=($(compgen -W "$(grep ^Host $HOME/.ssh/config | awk '{print $2}' )" -- ${COMP_WORDS[COMP_CWORD]}))
    fi
    if [ -r $HOME/.ssh/known_hosts ]; then
        if grep -v -q -e '^ ssh-rsa' $HOME/.ssh/known_hosts ; then
            COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$( awk '{print $1}' $HOME/.ssh/known_hosts | cut -d, -f 1 | sed -e 's/\[//g' | sed -e 's/\]//g' | cut -d: -f1 | grep -v ssh-rsa)" -- ${COMP_WORDS[COMP_CWORD]} ))
        fi
    fi
    return 0
}

complete -o default -o nospace -F _sshcomplete ssh
complete -o default -o nospace -F _sshcomplete ssh-copy-id
