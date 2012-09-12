#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Alias Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

alias ll="ls -l"
alias lsd='ll | grep "^d"'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -='cd -'
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
alias nano='nano -Eci'
alias du='du -kh'
alias du1='du -kh --max-depth=1'
alias du10='du -s * | sort -n | tail'
alias df='df -kTh'
alias tail='tail -n 200'
alias psgrep='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'
alias mount='mount | column -t'
alias lstree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'

#
# Safety
#
alias rm='rm -v'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

#
# Stats
#
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
