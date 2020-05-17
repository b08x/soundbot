#!/usr/bin/env bash

root=/home

hosts=soundbot,bender,

# perhaps git-annex can be used to track system changes
# like a git-commit for restore points
systemback=/usr/bin/systemback


git-annex=/usr/bin/git-annex

#
dotfiles=RCM

#if [ ! -d "/mnt/bender/backups" ]; then
#  sudo mount bender:/backups /mnt/bender/backups
#fi

rsync -r -t -p -o -g -v --progress -l -H --numeric-ids -s \
--exclude-from=/home/b08x/Workspace/soundbot/scripts/backup/exclude02.txt \
/home/b08x/ /mnt/bender/backups/b08x/

#if [ ! -d "/mnt/bender/media" ]; then
#  sudo mount bender:/media /mnt/bender/media
#fi

# sync from bender
rsync -r -n -g -v --progress --size-only -l -H -s \
/mnt/bender/media/music/ /home/b08x/Storage/media/music/

# sync to bender
rsync -r -g -v --progress --delete --size-only -l -H -s \
/home/b08x/Storage/media/music/ /mnt/bender/media/music/


#TODO: log output





sync lib to bender from soundbot
sync laptop with bender (bender pushes to laptop)
edit a file, on the laptop
sync laptop with bender (laptop pushes to bender)

create a new file on laptop
sync with bender, laptop pushes to bender
