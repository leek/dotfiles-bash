#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Alias Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

alias ls="ls -AFh"
alias ll="ls -l"
alias lsd='ll | grep "^d"'
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -='cd -'
alias grep="grep --color=auto"
alias timestamp='gawk "{now=strftime(\"%F %T \"); print now \$0; fflush(); }"'
alias cls="clear"
alias c="clear"
alias top="top -o cpu"
alias _="sudo"
alias _!="sudo !!"
alias awf="sudo !!"
alias h='history | grep'
alias md='mkdir -p'
alias mkdir="mkdir -p"
alias rd='rmdir'
alias fs='stat -f "%z bytes"'
alias nano='nano -Eciw'
alias du='du -kh'
alias du1='du -kh --max-depth=1'
alias du10='du -s * | sort -n | tail'
alias df='df -kTh'
alias tail='tail -n 200'
alias psgrep='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'
alias mount='mount | column -t'
alias lstree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
