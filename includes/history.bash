#!/usr/bin/env bash

# Append to bash_history if Terminal.app quits
shopt -s histappend

export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL="ignoredups"
export HISTCONTROL=erasedups
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
export AUTOFEATURE=true autotest

function rh {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
