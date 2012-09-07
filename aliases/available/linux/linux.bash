#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mAlias Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

alias ls="ls -AFh --color=auto"
alias grep="grep --color=auto"
