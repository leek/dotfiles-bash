#!/bin/bash

if [ ! `uname -s` == "Darwin" ]; then
    echo "Error : This should only be used with Mac OS X" >&2
    exit 1
fi

# +----------------------------------------------------------------------+
# |                                                                      |
# |  Set up Mac OS X to store temporary files in RAM rather than on disk.|
# |                                                                      |
# |  By Philipp Klaus <http://blog.philippklaus.de>                      |
# |                                                                      |
# |  Originally by Ricardo Gameiro <http://blogs.nullvision.com/?p=357>  |
# |  Changes by Daniel Jenkins                                           |
# |     <http://blogs.nullvision.com/?p=357#comment-1140>                |
# |                                                                      |
# +----------------------------------------------------------------------+

cd /System/Library/StartupItems
sudo mkdir -p RamFS
sudo chown -R root:wheel RamFS
sudo chmod -R u+rwX,g+rX,o+rX RamFS
cat << "EOF" | sudo tee RamFS/RamFS > /dev/null
#!/bin/sh
# Create a RAM disk with same perms as mountpoint

DEBUG=${2:-0}
if [[ $DEBUG == "--debug" ]]; then
    DEBUG=1
fi

RAMDisk() {
    mntpt=$1
    rdsize=$(($2*1024*1024/512))
    vol=$3
    echo "Creating RamFS for: $mntpt"
    # Create the RAM disk.
    if [[ $DEBUG == 1 ]]; then
        echo "Executing: hdik -drivekey system-image=yes -nomount ram://$rdsize"
    fi
    dev=`hdik -drivekey system-image=yes -nomount ram://$rdsize`
    # Successfull creation...
    if [ $? -eq 0 ] ; then
        # Create HFS on the RAM volume.
        if [[ $DEBUG == 1 ]]; then
            echo "Executing: newfs_hfs -v \"RAMDisk $vol\" $dev"
        fi
        newfs_hfs -v "RAMDisk $vol" $dev
        # Store permissions from old mount point.
        eval `/usr/bin/stat -s $mntpt`
        # Mount the RAM disk to the target mount point.
        mount -t hfs -o union -o nobrowse $dev $mntpt
        # Restore permissions like they were on old volume.
        chown $st_uid:$st_gid $mntpt
        chmod $st_mode $mntpt
    fi
}

# Test for arguments.
if [ -z $1 ]; then
    echo "Usage: $0 [start|stop|restart] [--debug]"
    exit 1
fi

# Source the common setup functions for startup scripts
test -r /etc/rc.common || exit 1
. /etc/rc.common

StartService () {
    ConsoleMessage "Starting RamFS Disks..."
    RAMDisk /private/tmp 256 "Temp"
    RAMDisk /var/run 64 "Run"
}

StopService () {
    ConsoleMessage "Stopping RamFS disks, nothing will be done here..."
    diskutil unmount /private/tmp /private/var/run
    diskutil unmount /private/var/run
}

RestartService () {
    ConsoleMessage "Restarting RamFS disks, nothing will be done here..."
}

RunService "$1"
EOF
sudo chmod u+x,g+x,o+x RamFS/RamFS


cat << EOF | sudo tee RamFS/StartupParameters.plist > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist SYSTEM "file://localhost/System/Library/DTDs/PropertyList.dtd">
<plist version="0.9">
    <dict>
        <key>Description</key>
        <string>RamFS Disks Manager</string>
        <key>OrderPreference</key>
        <string>Early</string>
        <key>Provides</key>
        <array>
            <string>RamFS</string>
        </array>
        <key>Uses</key>
        <array>
            <string>Disks</string>
        </array>
    </dict>
</plist>
EOF
