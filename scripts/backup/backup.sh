#!/usr/bin/env bash

#if [ ! -d "/mnt/bender/backups" ]; then
#  sudo mount bender:/storage /mnt/bender
#fi

#rsync -r -t -v --progress -s /home/b08x/studio/ /mnt/bender/backups/studio/

#sudo umount /mnt/bender


# git repos to backup;
.dotfiles
workspace
#~/studio/sessions
#~/Notebooks/Notes
#~/workspace/*
#yadm

##cd into each dir
##display git diff
##prompt for commit comment


# sync the library to bender, if a file exists on bender that is not on soundbot it will be deleted
rsync -r -t -p -o -g -v --progress --delete -u -l -H -z -i -s /home/b08x/studio/library/ /mnt/bender/backups/studio/library/

# when syncing laptop, run rsync to pull from bender, removing anything on the laptop that is not on bender
so,

sync lib to bender from soundbot
sync laptop with bender (bender pushes to laptop)
edit a file, on the laptop
sync laptop with bender (laptop pushes to bender)

create a new file on laptop
sync with bender, laptop pushes to bender
