#!/usr/bin/env bash
# Personal .bashrc file for interactive bash(1) shells.

# Add to end of $PATH
path_push() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# Prepend to beginning of $PATH
path_unshift() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# Don't continue if this is being sourced from a non-interactive shell
[[ $- != *i* ]] && return

# DF_DEBUG=1

if [[ $DF_DEBUG ]]; then
    echo ""
    echo -e "\033[1;32mLoaded:\033[39m $(basename ${BASH_SOURCE[0]})"
fi

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
fi

if [[ $DF_DEBUG ]]; then
    echo ""
fi
