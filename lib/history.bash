#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="&:ls:ls *:cd:cd -:pwd;exit:date:* --help *:mutt:[bf]g:exit"
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
AUTOFEATURE=true autotest

function rh {
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
