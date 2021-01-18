#!/bin/sh

rsync -av --delete --exclude={/home/jb/.cache,/home/jb/.var/app/com.valvesoftware.Steam} /home /run/media/jb/BackupPlus/surf@arch
