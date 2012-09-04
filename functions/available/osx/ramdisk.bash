ramdisk_umount() {
    local volume=$1
    local hdid=$2
    umount "/Volumes/$volume"
    hdiutil detach "$hdid"
}

ramdisk_mount(){
    local volume=$1
    local hdid=$2
    local size=$3*1024*1024/512
    local id=`hdiutil attach -nomount ram://$size`
    if [ ${id} == $hdid ]; then
        diskutil eraseDisk HFS+ "$volume" "$hdid"
    else
        return 1
    fi
}
