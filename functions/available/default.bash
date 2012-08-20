#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mFunction Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

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

function ask {
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

function ii()
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
    echo -e "\n${RED}Open connections :$NC "; netstat -pan --inet;
    echo
}
