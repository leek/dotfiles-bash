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
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
