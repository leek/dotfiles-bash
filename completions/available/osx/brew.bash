#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mCompletion Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

if which brew > /dev/null 2>&1; then
    if [ -f $HOMEBREW_PREFIX/etc/bash_completion ]; then
        . $HOMEBREW_PREFIX/etc/bash_completion
    fi

    if [ -f $HOMEBREW_PREFIX/Library/Contributions/brew_bash_completion.sh ]; then
        . $HOMEBREW_PREFIX/Library/Contributions/brew_bash_completion.sh
    fi
fi
