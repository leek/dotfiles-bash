function trash() {
    mv $@ ~/.Trash/
}

function usage() {
    if [ -n $1 ]; then
        du -hd $1
    else
        du -hd 1
    fi
}
