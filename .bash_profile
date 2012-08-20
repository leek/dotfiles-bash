#!/usr/bin/env bash

UNAME=$(uname)
DF_ITEM_TYPES=( aliases completions functions )
DF_CUSTOM_EXCLUDE=( before.bash after.bash )
# DF_DEBUG=1

if [[ $DF_DEBUG ]]; then
    echo ""
    echo -e "\033[1;32mLoaded:\033[39m $(basename ${BASH_SOURCE[0]})"
fi

export PATH="~/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export SHORT_USER="$USER"
export DOTFILES="$HOME/.dotfiles"
export EDITOR='nano'
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

# Unset options
shopt -u mailwarn
unset MAILCHECK

[[ -e $DOTFILES/custom/before.bash ]] && source $DOTFILES/custom/before.bash

source $DOTFILES/lib/core.bash
source $DOTFILES/lib/colors.bash
source $DOTFILES/lib/prompt.bash
source $DOTFILES/lib/history.bash
source $DOTFILES/lib/colorful.bash

[[ is_mac ]] && source $DOTFILES/lib/osx.bash
[[ is_linux ]] && source $DOTFILES/lib/linux.bash

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

if [[ $DF_DEBUG ]]; then
    echo ""
fi
