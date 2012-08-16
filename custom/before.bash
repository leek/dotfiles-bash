#!/usr/bin/env bash

if [[ "$USER" = "chris.jones" ]]; then
    export SHORT_USER="leek"
fi

export GIT_AUTHOR_NAME="Chris Jones"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_AUTHOR_EMAIL="leeked@gmail.com"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
