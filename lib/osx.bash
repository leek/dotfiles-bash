#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

export GEM_HOME="$HOME/.gem"
export GEM_PATH="$GEM_HOME:/Library/Ruby/Gems/1.8"
export RUBYOPT=rubygems

mkdir -p "$GEM_HOME/bin" "$GEM_HOME/lib" "$GEM_HOME/src"
path_unshift "$GEM_HOME/bin"

# Editor defaults
if [[ -x "`which subl`" ]]; then
    EDITOR='subl -w'
    GIT_EDITOR='subl -w'
    LESSEDIT='subl %f:%1m'
elif [[ -x "`which mate`" ]]; then
    EDITOR='mate -w'
    GIT_EDITOR='mate -w'
    LESSEDIT='mate -l %lm %f'
fi

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
fi

# Add global node_modules to PATH if available
if [[ -d /usr/local/lib/node_modules ]]; then
    export NODE_PATH="/usr/local/lib/node_modules"
fi
