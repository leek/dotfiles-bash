#!/usr/bin/env bash

# Initial PATH
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Add global node_modules to PATH if available
if [ -d /usr/local/lib/node_modules ]; then
    export NODE_PATH="/usr/local/lib/node_modules"
fi

# For permissions on OSX
if [[ "$OSTYPE" =~ ^darwin ]]; then
    export GEM_HOME="$HOME/.gem"
    export GEM_PATH="$HOME/.gem"
    export RUBYOPT=rubygems
fi

if [[ -z "$SHORT_USER" ]]; then
    export SHORT_USER="$USER"
fi

# Editor defaults
if [[ -x "`which subl`" ]]; then
    export EDITOR='subl -w'
    export GIT_EDITOR='subl -w'
    export LESSEDIT='subl %f:%1m'
elif [[ -x "`which mate`" ]]; then
    export EDITOR='mate -w'
    export GIT_EDITOR='mate -w'
    export LESSEDIT='mate -l %lm %f'
else
    export EDITOR='nano'
fi

export FIGNORE="CVS:.DS_Store:.svn"
export PAGER='less -SFX'
export MAKEFLAGS='-j 3'
export LC_ALL="en_US.UTF-8"
export LANG="en_US"
export LC_CTYPE="en_US.UTF-8"

set -o notify

shopt -s checkwinsize
shopt -s nocaseglob
shopt -u mailwarn

unset MAILCHECK

# Main directory
DOTFILES="$HOME/.dotfiles"

if [ -e $DOTFILES/custom/before.bash ]; then
    source $DOTFILES/custom/before.bash
fi

# Includes
source "$DOTFILES/includes/colors.bash"
source "$DOTFILES/includes/prompt.bash"
source "$DOTFILES/includes/history.bash"
source "$DOTFILES/includes/colorful.bash"

# Load enabled
for source_type in "aliases" "completions" "functions"; do
    if [ ! -d $DOTFILES/$source_type/enabled ]; then
        continue
    fi
    for source_file in $DOTFILES/$source_type/enabled/*; do
        if [ -e $source_file ]; then
            source $source_file
        fi
    done
done

# Load all custom
special_custom=( before.bash after.bash )
for source_file in $DOTFILES/custom/*; do
    if [ -e $source_file ]; then
        source $source_file
    fi
done

if [[ $PROMPT ]]; then
    export PS1=$PROMPT
fi
