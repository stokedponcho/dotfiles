#!/bin/sh

picom &
light-locker &
${XDG_CONFIG_HOME:-$HOME/.config/}/fehbg
