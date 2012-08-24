#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"
SHORT_USER="$USER"
UNAME=$(uname)
DF_ITEM_TYPES=( aliases completions functions )
DF_CUSTOM_EXCLUDE=( before.bash after.bash )

if [[ $DF_DEBUG ]]; then
    echo -e "\033[1;32mLoaded:\033[39m $(basename ${BASH_SOURCE[0]})"
fi

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

path_unshift "~/bin"
path_push "/opt/local/bin"
path_push "/opt/local/sbin"

export EDITOR='nano -w'
export GIT_EDITOR='nano -w'
export LESSEDIT='nano -w'
export FIGNORE="CVS:.DS_Store:.svn"
export PAGER='less -SFX'
export MAKEFLAGS='-j 3'
export LC_ALL="en_US.UTF-8"
export LANG="en_US"
export LC_CTYPE="en_US.UTF-8"

set -o notify

# Set options
shopt -s checkwinsize
shopt -s nocaseglob
shopt -s dotglob
shopt -s cdspell
shopt -s no_empty_cmd_completion
shopt -s histappend

# Unset options
shopt -u mailwarn
unset MAILCHECK

[[ -e $DOTFILES/custom/before.bash ]] && source $DOTFILES/custom/before.bash

source $DOTFILES/lib/core.bash
source $DOTFILES/lib/colors.bash
source $DOTFILES/lib/history.bash
source $DOTFILES/lib/colorful.bash

if [[ -e $DOTFILES/.bash_prompt ]]; then
    source $DOTFILES/lib/prompt.bash
    source $DOTFILES/.bash_prompt
fi

if [[ is_mac ]]; then
    source $DOTFILES/lib/osx.bash
elif [[ is_linux ]]; then
    source $DOTFILES/lib/linux.bash
fi

# Load enabled types
for item_type in "${DF_ITEM_TYPES[@]}"; do
    _df_load_enabled_by_type $item_type
done

# Load all custom
for custom_file in $DOTFILES/custom/*.bash; do
    in_array "$custom_file" "${DF_CUSTOM_EXCLUDE[@]}" && continue
    [[ -x $DOTFILES/custom/$custom_file ]] && source $DOTFILES/custom/$custom_file
done

[[ -e $DOTFILES/custom/after.bash ]] && source $DOTFILES/custom/after.bash
