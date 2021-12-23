#!/bin/bash

pgrep -x sxhkd && exit 0

sxhkdrc="$XDG_CONFIG_HOME"/sxhkd/sxhkdrc
wmrc="$XDG_CONFIG_HOME"/sxhkd/"$WM"rc

if [[ -f "$wmrc" ]]; then
	sxhkd -c "$sxhkdrc" "$wmrc" &
else
	sxhkd -c "$sxhkdrc" &
fi
