#!/bin/sh
# Set brightness via xbrightness when redshift status changes

# Set brightness values for each status.
# Range from 1 to 100 is valid
brightness_day=100
brightness_transition=75
brightness_night=50

# Set fps for smoooooth transition
fps=1000

set_brightness() {
		xbacklight -set $1 -time $fps
}

if [ "$1" = period-changed ]; then
	case $3 in
		night)
			set_brightness $brightness_night
			;;
		transition)
			set_brightness $brightness_transition
			;;
		daytime)
			set_brightness $brightness_day
			;;
	esac
fi
