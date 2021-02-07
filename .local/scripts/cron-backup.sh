#!/bin/dash

# To restore:
# crontab .config/crontab.bak

crontab -l > ${XDG_CONFIG_HOME:-$HOME/.config}/crontab.bak
