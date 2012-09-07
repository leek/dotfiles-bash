#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mFunction Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

function git-remove-missing-files() {
    git ls-files -d -z | xargs -0 git update-index --remove
}

# Adds files to git's exclude file (same as .gitignore)
function git-add-local-ignore() {
    echo "$1" >> .git/info/exclude
}

function git-remove-all-tags() {
    local remote=${1:origin}
    for t in `git tag`; do
        git push $remote :$t && git tag -d $t
    done
}

function git-stop-working-in-master() {
    local $new_branch=$1
    git branch $new_branch
    git reset --hard HEAD
    git checkout $new_branch
}
