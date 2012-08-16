#!/usr/bin/env bash

ips () {
    ifconfig | grep "inet " | awk '{ print $2 }'
}

myip () {
    res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
    echo -e "Your public IP is: ${echo_bold_green} $res ${echo_normal}"
    if [[ "$OSTYPE" =~ ^darwin ]]; then
        `echo "$res" | pbcopy`
    fi
}

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

lsgrep () {
    ls | grep "$*"
}

pman () {
    man -t "${1}" | open -f -a $PREVIEW
}

pcurl () {
    curl "${1}" | open -f -a $PREVIEW
}

usage () {
    if [ $(uname) = "Darwin" ]; then
        if [ -n $1 ]; then
            du -hd $1
        else
            du -hd 1
        fi

    elif [ $(uname) = "Linux" ]; then
        if [ -n $1 ]; then
            du -h --max-depth=1 $1
        else
            du -h --max-depth=1
        fi
    fi
}

command_exists () {
    type "$1" &> /dev/null ;
}

mkbak () {
    local filename=$1
    local filetime=$(date +%Y%m%d_%H%M%S)
    cp ${filename} ${filename}_${filetime}
}

trash() {
    mv $@ ~/.Trash/
}
