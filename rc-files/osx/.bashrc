#!/usr/bin/env bash
# Personal .bashrc file for interactive bash(1) shells.

# If not running interactively, don't do anything
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
