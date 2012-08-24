#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL="ignoredups"
export HISTCONTROL=erasedups
export HISTIGNORE="&:ls:ls *:cd:cd -:pwd;exit:date:* --help *:mutt:[bf]g:exit"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
export AUTOFEATURE=true autotest

function rh {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
