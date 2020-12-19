#!/bin/dash

#
# Run checkbashims on all scripts within .local/scripts folder

find ~/.local/scripts -type f -perm -o=r -print0 | xargs -0 gawk '/^#!.*( |[/])sh/{printf "%s\0", FILENAME} {nextfile}' | xargs -0 checkbashisms
find ~/.local/scripts -type f -perm -o=r -print0 | xargs -0 gawk '/^#!.*( |[/])dash/{printf "%s\0", FILENAME} {nextfile}' | xargs -0 checkbashisms
