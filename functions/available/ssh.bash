#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mFunction Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

function ssh-list() {
    awk '$1 ~ /Host$/ { print $2 }' ~/.ssh/config
}

function putty2ssh_private() {
    puttygen "$1" -O private-openssh -o "${1}-ssh"
}
