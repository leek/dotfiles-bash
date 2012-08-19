#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mCompletion Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

if which brew > /dev/null 2>&1; then
    export HOMEBREW_TEMP=/usr/local/tmp
    BREW_PREFIX="/usr/local"
    BREW_PREFIX_PHP=`brew --prefix php53`

    # Load Homebrew's shell completion
    if [ -f $BREW_PREFIX/etc/bash_completion ]; then
        . $BREW_PREFIX/etc/bash_completion
    fi

    if [ -f $BREW_PREFIX/Library/Contributions/brew_bash_completion.sh ]; then
        . $BREW_PREFIX/Library/Contributions/brew_bash_completion.sh
    fi

    # Load GRC
    if [ -f $BREW_PREFIX/etc/grc.bashrc ]; then
        . $BREW_PREFIX/etc/grc.bashrc
    fi

    # homebrew-php
    if [ -d $PHP_BREW_PREFIX/bin ]; then
        export PATH="$PHP_BREW_PREFIX/bin:$PATH"
    fi
fi
