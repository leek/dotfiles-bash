#!/usr/bin/env bash

function prompt_command() {
    # user@hostname: /path (git) $
    PS1="${green}$SHORT_USER@\\h: ${blue}\\w ${red}"'$(__git_ps1 "(%s) ")'"${purple}\\$ ${reset_color}"
}

PROMPT_COMMAND=prompt_command;
