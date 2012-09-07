#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

# * unstaged changes
# + staged changes
export GIT_PS1_SHOWDIRTYSTATE=1

# $ stashed changes
# export GIT_PS1_SHOWSTASHSTATE=1

# % untracked files
# export GIT_PS1_SHOWUNTRACKEDFILES=1

function scm {
    if [[ -d .git ]] || [[ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]]; then
        SCM='git'
    elif [[ -d .hg ]] || [[ -n "$(hg root 2> /dev/null)" ]]; then
        SCM='hg'
    elif [[ -d .svn ]]; then
        SCM='svn'
    else
        SCM='none'
    fi
}

function git_prompt {
    local gitps1
    declare -F __git_ps1 >/dev/null && gitps1=$(__git_ps1 "%s")
    if [[ $gitps1 ]]; then
        if [[ ! -z $GIT_PS1_SHOWDIRTYSTATE ]]; then
            case $gitps1 in
                *\* )
                    # Unstaged
                    echo -e "${red}${gitps1/ */} "
                    ;;
                *\+ )
                    # Staged
                    echo -e "${yellow}${gitps1/ */} "
                    ;;
                * )
                    echo -e "${green}${gitps1} "
            esac
        else
            echo -e "${bold_red}${gitps1} "
        fi
    fi
}

function right_align() {
    local output=$1
    local prompt_cols=${#PS1}
    local push_cols=$((COLUMNS-prompt_cols))
    echo -e "\033[s\033[${push_cols}C${output}\033[u"
}

function prompt_status() {
    if [ $? = 0 ]; then
        echo -e "${green}${SYMBOL_POSITIVE} ${reset_color}";
    else
        echo -e "${red}${SYMBOL_NEGATIVE} ${reset_color}";
    fi
}

function update_title() {
    echo -e "\033]0;$SHORT_USER@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"
}
