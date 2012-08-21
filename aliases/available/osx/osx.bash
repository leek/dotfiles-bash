#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mAlias Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

alias preview="open -a '$PREVIEW'"
alias safari="open -a safari"
alias firefox="open -a firefox"
alias chrome="open -a google\ chrome"
alias f='open -a Finder '
alias fh='open -a Finder .'

# OS X has no `md5sum`, so use `md5` as a fallback
type -t md5sum > /dev/null || alias md5sum="md5"

# Recursively delete `.DS_Store` files
alias clean-ds_store="find . -name '*.DS_Store' -type f -ls -delete"

# Speed up Terminal.app
alias clean-asl="sudo rm -rf /private/var/log/asl/*.asl"
