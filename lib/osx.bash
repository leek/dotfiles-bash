#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mLoaded:\033[39m $(basename ${BASH_SOURCE[0]})"

export GEM_HOME="$HOME/.gem"
export GEM_PATH="$HOME/.gem"
export RUBYOPT=rubygems

# Editor defaults
if [[ -x "`which subl`" ]]; then
    export EDITOR='subl -w'
    export GIT_EDITOR='subl -w'
    export LESSEDIT='subl %f:%1m'
elif [[ -x "`which mate`" ]]; then
    export EDITOR='mate -w'
    export GIT_EDITOR='mate -w'
    export LESSEDIT='mate -l %lm %f'
fi

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
fi

# Add global node_modules to PATH if available
if [[ -d /usr/local/lib/node_modules ]]; then
    export NODE_PATH="/usr/local/lib/node_modules"
fi
