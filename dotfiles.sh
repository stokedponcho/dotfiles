#!/bin/bash

stow . -v
[[ -d "/usr/share/libalpm/hooks" ]] && stow pacman-hooks --target="/usr/share/libalpm/hooks" -v
