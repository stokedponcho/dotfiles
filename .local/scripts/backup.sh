#!/bin/sh

rsync -av --delete --exclude={/home/jb/.cache,/home/jb/.local/share/containers,/home/jb/.local/share/libvirt/images,/home/jb/.local/src,/home/jb/.var/app/com.valvesoftware.Steam,/home/jb/Games} /home /run/media/jb/BackupPlus/surf@arch
