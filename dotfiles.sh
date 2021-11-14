#!/bin/dash

stow . -v
stow pacman-hooks --target="/usr/share/libalpm/hooks" -v
