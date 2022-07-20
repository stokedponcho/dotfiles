#!/bin/bash
# Script to listen to capture device with awesomewm
# This solution is used to leverage 'pactl subscribe'
#
# Credits to
# https://github.com/arcolinux/arcolinux-polybar/blob/master/etc/skel/.config/polybar/scripts/pavolume.sh
# https://github.com/marioortizmanero/polybar-pulseaudio-control
#

output() {
  defaultSource=$(pactl info | grep "Default Source" | cut -f3 -d" ")
  volume=$(pacmd list-sources | grep -A 10 $defaultSource | awk -e '/volume/{ print $5 }' | head -n 1)
  volume=${volume/"%"/""}
  muted=$(pacmd list-sources | grep -A 10 $defaultSource | awk '/muted/{ print $2 }')

  if [ $muted = "yes" ]; then
    echo "<span color='#999'> $volume</span>"
  else
    echo " $volume"
  fi
}

firstRun=0

# Listen for changes and immediately create new output for the bar.
# This is faster than having the script on an interval.
pactl subscribe 2>/dev/null | {
  while true; do
      {
        # If this is the first time just continue and print the current
        # state. Otherwise wait for events. This is to prevent the
        # module being empty until an event occurs.
        if [ $firstRun -eq 0 ]; then
          firstRun=1
        else
          read -r event || break
          # Avoid double events
          if ! echo "$event" | grep -e "on card" -e "on source" -e "on server"; then
            continue
          fi
        fi
      } >/dev/null 2>&1
      output
  done
}
