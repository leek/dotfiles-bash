#!/bin/bash -e
cd

[ -d .dotfiles ] || git clone git://github.com/leek/dotfiles.git .dotfiles
(
    set -e
    cd .dotfiles

    TEMPFILE="`mktemp -t install.XXXXXX`"
    trap '{ rm -f "$TEMPFILE"; }' EXIT
)

function create_link()
{
    local SRC="$1"
    local DST="$2"
    if [ ! -e "$DST" ]; then
        ln -sv "$SRC" "$DST"
    else
        if [ ! -L "$DST" ] || [ "`readlink "$DST"`" != "$SRC" ]; then
            echo -n "dotfiles: $DST already exists" >&2
            if [ -L "$DST" ]; then
                echo " (pointing to `readlink "$DST"`)"
            else
                echo " (not a symlink)"
            fi
        fi
    fi
}

to_link=( .bashrc .bash_profile .inputrc .nano .nanorc .mongorc.js .gemrc )
to_copy=( .gitconfig )

find .dotfiles -maxdepth 1 -not -name .git | while read SRC
do
    DST="`echo "$SRC" | sed -e 's#.*/##'`"
	if [[ ${to_link[@]} =~ $DST ]]; then
        echo "Linking $SRC -> $DST"
		create_link "$SRC" "$DST"
    elif [[ ${to_copy[@]} =~ $DST ]]; then
        echo "Copying $SRC -> $DST"
        cp "$SRC" "$DST"
	fi
done
