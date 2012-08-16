#!/usr/bin/env bash

function git_remove_missing_files() {
  git ls-files -d -z | xargs -0 git update-index --remove
}

# Adds files to git's exclude file (same as .gitignore)
function local-ignore() {
  echo "$1" >> .git/info/exclude
}
