#!/bin/bash

# Debug/Profile start
# PS4='+ $(date "+%s.%N")\011 '
# exec 3>&2 2>/Users/chris.jones/bashstart.$$.log
# set -x
# Debug/Profile end

[ -n "$PS1" ] && source ~/.bash_profile

PROMPT_COMMAND="$PROMPT_COMMAND"'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD##*/}\007"'

# Debug/Profile start
# set +x
# exec 2>&3 3>&-
# Debug/Profile end
