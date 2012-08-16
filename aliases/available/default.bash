#!/usr/bin/env bash

alias ls="ls -GAFh"
alias ll="ls -l"
alias lsd='ll | grep "^d"'
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -='cd -'

if [[ -x "`which gls`" ]]; then
  alias ls="gls -GAFh --color=always"
fi

alias grep="grep --color=auto"
alias timestamp='gawk "{now=strftime(\"%F %T \"); print now \$0; fflush(); }"'
alias cls="clear"
alias c="clear"
alias s="subl"
alias m="mate"
alias top="top -o cpu"
alias _="sudo"
alias h='history | grep'
alias md='mkdir -p'
alias mkdir="mkdir -p"
alias rd='rmdir'
alias fs='stat -f "%z bytes"'
