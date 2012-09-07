function usage() {
    if [ -n $1 ]; then
        du -h --max-depth=1 $1
    else
        du -h --max-depth=1
    fi
}
