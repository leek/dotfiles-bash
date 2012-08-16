#!/usr/bin/env bash

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

function scm_prompt {
    scm
    [[ $SCM == 'git' ]] && git_prompt && return
}

function git_prompt {
    local ref=$(git symbolic-ref HEAD 2> /dev/null)
    local branch=${ref#refs/heads/}
    if [[ -n $(git status -s 2> /dev/null | grep -v ^# | grep -v "working directory clean") ]]; then
        echo -en "${echo_red}(${branch}) "
    else
        echo -en "${echo_yellow}(${branch}) "
    fi
}

function prompt_command() {
    PS1="${green}$SHORT_USER@\\h: ${blue}\\w $(scm_prompt)${purple}\\$ ${reset_color}"
}

PROMPT_COMMAND=prompt_command;
