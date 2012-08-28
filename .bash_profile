#!/usr/bin/env bash
# Order (first one that exists):
#   ~/.bash_profile
#   ~/.bash_login
#   ~/.profile

if [[ $DF_DEBUG ]]; then
    echo -e "\033[1;32mLoaded:\033[39m $(basename ${BASH_SOURCE[0]})"
fi

# Local variables
SHORT_USER="$USER"
DOTFILES="$HOME/dotfiles"

# PATH
if [[ -d /usr/local/bin ]]; then
    export PATH="/usr/local/bin:$PATH"
fi

if [[ -d /usr/local/sbin ]]; then
    export PATH="/usr/local/sbin:$PATH"
fi

if [[ -d "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# Exported variables
export UNAME=$(uname)
export EDITOR='nano -w'
export GIT_EDITOR='nano -w'
export LESSEDIT='nano -w'
export FIGNORE="CVS:.DS_Store:.svn"
export PAGER='less -SFX'
export MAKEFLAGS='-j 3'
export LC_ALL="en_US.UTF-8"
export LANG="en_US"
export LC_CTYPE="en_US.UTF-8"

unset MAILCHECK
set -o notify

source $DOTFILES/lib/history.bash
source $DOTFILES/lib/options.bash

[[ -e $DOTFILES/custom/before.bash ]] && source $DOTFILES/custom/before.bash

source $DOTFILES/lib/core.bash
source $DOTFILES/lib/colors.bash
source $DOTFILES/lib/history.bash
source $DOTFILES/lib/colorful.bash

if [[ -e $DOTFILES/.bash_prompt ]]; then
    source $DOTFILES/lib/prompt.bash
    source $DOTFILES/.bash_prompt
fi

if [[ $UNAME == "Darwin" ]]; then
    source $DOTFILES/lib/osx.bash
elif [[ $UNAME == "Linux" ]]; then
    source $DOTFILES/lib/linux.bash
fi

# Load enabled types
for item_type in "aliases" "completions" "functions"; do
    _df_load_enabled_by_type $item_type
done

# Load all custom
for filepath in $DOTFILES/custom/*.bash; do
    filename="$(basename $filepath)"
    if [[ $filename == 'after.bash' || $filename == 'before.bash' ]]; then
        continue
    fi
    [[ -x $DOTFILES/custom/$filename ]] && source $DOTFILES/custom/$filename
done

[[ -e $DOTFILES/custom/after.bash ]] && source $DOTFILES/custom/after.bash
