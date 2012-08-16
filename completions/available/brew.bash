if which brew > /dev/null 2>&1; then
    BREW_PREFIX=`brew --prefix`

    # Load Homebrew's shell completion
    if [ -f "$BREW_PREFIX/etc/bash_completion" ]; then
        . "$BREW_PREFIX/etc/bash_completion"
    fi

    if [ -f "$BREW_PREFIX/Library/Contributions/brew_bash_completion.sh" ]; then
        . "$BREW_PREFIX/Library/Contributions/brew_bash_completion.sh"
    fi

    # Load GRC
    if [ -f "$BREW_PREFIX/etc/grc.bashrc" ]; then
        . "$BREW_PREFIX/etc/grc.bashrc"
    fi

    # homebrew-php
    PHP_BREW_PREFIX=`brew --prefix php53`
    if [ -d "$PHP_BREW_PREFIX/bin" ]; then
        export PATH="$PHP_BREW_PREFIX/bin:$PATH"
    fi

    # Set custom temp directory
    export HOMEBREW_TEMP=/usr/local/tmp
fi
