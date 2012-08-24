#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32m  Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

function prompt_command() {
    PS1="$(prompt_status)${bold_black}$SHORT_USER@\\h ${blue}\\w $(git_prompt)${purple}\\$ ${reset_color}"
}

PROMPT_COMMAND="$PROMPT_COMMAND prompt_command; update_title"
