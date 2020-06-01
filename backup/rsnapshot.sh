#!/bin/bash

## my own rsync-based snapshot-style backup procedure
## (cc) marcio rps AT gmail.com

# config vars

SRC="/home/b08x/" #dont forget trailing slash!
SNAP="/mnt/bender/backups/b08x"
OPTS="-rltgoi --delay-updates --chmod=a-w --progress --exclude=*.git/** --exclude=*.svn/** --exclude-from=/home/b08x/Workspace/soundbot/backup/exclude.txt"
MINCHANGES=20

# run this process with real low priority

#ionice -c 3 -p $$
#renice +12  -p $$
MOUNT_STATUS=$(mount | grep backups)
MOUNT_CMD="sudo /bin/mount bender:/backups /mnt/bender/backups"

# sync
if [ -z $MOUNT_STATUS ]
  then
    echo "mounting bender"
    $MOUNT_CMD
fi

rsync $OPTS $SRC $SNAP/latest >> $SNAP/rsync.log

#check if enough has changed and if so
#make a hardlinked copy named as the date

COUNT=$( wc -l $SNAP/rsync.log|cut -d" " -f1 )
if [ $COUNT -gt $MINCHANGES ] ; then
        DATETAG=$(date +%Y-%m-%d-%H%M%S)
        if [ ! -e $SNAP/$DATETAG ] ; then
                echo "using ssh to login to bender to run the link command locally"
                ssh bender "cp -avl /backups/b08x/latest /backups/b08x/$DATETAG"
                chmod u+w $SNAP/$DATETAG
                mv $SNAP/rsync.log $SNAP/$DATETAG
                chmod u-w $SNAP/$DATETAG
         fi
fi
