#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
MONITOR=$(polybar --list-monitors | grep -i primary | cut -d":" -f1) polybar --reload primary &

for m in $(polybar --list-monitors | grep -iv primary | cut -d":" -f1); do
    MONITOR=$m polybar --reload secondary &
done
