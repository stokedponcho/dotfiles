#!/bin/sh

pactl load-module module-null-sink
pavucontrol &
onboard &
chromium https://www.duolingo.com/ &
gxkb &
sox -t pulseaudio default -t pulseaudio null pitch -400
