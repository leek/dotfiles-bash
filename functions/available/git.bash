#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mFunction Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

function git_df-remove-missing-files() {
  git ls-files -d -z | xargs -0 git update-index --remove
}

# Adds files to git's exclude file (same as .gitignore)
function git_df-local-ignore() {
  echo "$1" >> .git/info/exclude
}

function git_df-remove-all-tags() {
    for t in `git tag`; do
        git push origin :$t && git tag -d $t
    done
}
