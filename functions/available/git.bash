#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mFunction Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

function git_remove_missing_files() {
  git ls-files -d -z | xargs -0 git update-index --remove
}

# Adds files to git's exclude file (same as .gitignore)
function git_local_ignore() {
  echo "$1" >> .git/info/exclude
}
