#!/bin/bash -e

#
# Compiled and copied from various authors
#  - https://github.com/jasoncodes/dotfiles/blob/master/install.sh
#

cd

[ -d .dotfiles ] || git clone git://github.com/leek/dotfiles.git .dotfiles
(
    set -e
    cd .dotfiles

    TEMPFILE="`mktemp -t install.XXXXXX`"
    trap '{ rm -f "$TEMPFILE"; }' EXIT

    set +e
    git fetch origin
    git show origin/master:profile > "$TEMPFILE"
    source "$TEMPFILE"
    set -e

    gup
)

function create_link()
{
    local SRC="$1"
    local DST="$2"

    if [ ! -e "$DST" ]
    then
        ln -sv "$SRC" "$DST"
    else
        if [ ! -L "$DST" ] || [ "`readlink "$DST"`" != "$SRC" ]
        then
            echo -n "dotfiles: $DST already exists" >&2
            if [ -L "$DST" ]
            then
                echo " (pointing to `readlink "$DST"`)"
            else
                echo " (not a symlink)"
            fi
        fi
    fi
}

find .dotfiles -maxdepth 1 -type f -not -name 'install.sh' -not -name 'README*' | while read SRC
do
    DST="`echo "$SRC" | sed -e 's#.*/#.#'`"
    if echo "$SRC" | grep -q /profile$
    then
        create_link "$SRC" .bash_profile
        create_link "$SRC" .bashrc
    else
        create_link "$SRC" "$DST"
    fi
done