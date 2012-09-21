#!/usr/bin/env bash

DF_DEBUG=1
[[ $DF_DEBUG ]] && echo -e "\033[1;32mLoaded:\033[39m $(basename ${BASH_SOURCE[0]})"

# PATH
if [[ -d /usr/local/sbin ]]; then
    export PATH="/usr/local/sbin:$PATH"
fi

if [[ -d /usr/local/bin ]]; then
    export PATH="/usr/local/bin:$PATH"
fi

if [[ -d "${HOME}/bin" ]]; then
    export PATH="${HOME}/bin:$PATH"
fi

# Add global node_modules to PATH if available
# if [[ -d /usr/local/lib/node_modules ]]; then
#     export NODE_PATH="/usr/local/lib/node_modules"
# fi

# Exported variables
export SHORT_USER="$USER"
export DOTFILES="$HOME/dotfiles"
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
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Colors
export BLACK=$(tput setaf 0)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export MAGENTA=$(tput setaf 5)
export CYAN=$(tput setaf 6)
export NORMAL=$(tput setaf 7)
export BOLD=$(tput bold)
export RESET=$(tput sgr0)

unset MAILCHECK
set -o notify

#
# History control
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="&:ls:ls *:cd:cd -:pwd;exit:date:* --help *:mutt:[bf]g:exit"
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "

#
# Options
source $DOTFILES/lib/options.bash

[[ -e $DOTFILES/custom/before.bash ]] && source $DOTFILES/custom/before.bash

source $DOTFILES/lib/colors.bash
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
    for item_file in $DOTFILES/$item_type/enabled/*; do
        [[ -e $item_file ]] && source $item_file
    done
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

# Unset local variables
unset filename
unset filepath
unset item_type
unset item_file
