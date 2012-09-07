#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

# export GEM_HOME="$HOME/.gem"
# export GEM_PATH="$GEM_HOME:/Library/Ruby/Gems/1.8"
export RUBYOPT=rubygems
export HOMEBREW_TEMP="/usr/local/tmp"
export HOMEBREW_PREFIX="/usr/local"

# gem binaries
HOMEBREW_RUBY_PREFIX="$(brew --prefix ruby)"
if [[ -d "${HOMEBREW_RUBY_PREFIX}/bin" ]]; then
    export PATH="${HOMEBREW_RUBY_PREFIX}/bin:$PATH"
fi

# grc
if [ -f $HOMEBREW_PREFIX/etc/grc.bashrc ]; then
    source $HOMEBREW_PREFIX/etc/grc.bashrc
fi

# Editor defaults
if command_exists "subl"; then
    EDITOR='subl -w'
    GIT_EDITOR='subl -w'
    LESSEDIT='subl %f:%1m'
elif command_exists "mate"; then
    EDITOR='mate -w'
    GIT_EDITOR='mate -w'
    LESSEDIT='mate -l %lm %f'
fi

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
fi

# Taken from /etc/bashrc on OSX 10.8
if [ "$TERM_PROGRAM" == "iTerm.app" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
        local SEARCH=' '
        local REPLACE='%20'
        local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
        printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi
