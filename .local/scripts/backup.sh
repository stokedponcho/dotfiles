#!/bin/bash

root="/run/media/jb/BackupPlus"
destination="$root/surf@arch"

include_file="$(mktemp)"

\ls "$HOME" > "$include_file"

#rsync --dry-run -av \
	#--include="$HOME/.dotfiles"				\
	#--include="$HOME/.ssh"						\
	#--include-from="$include_file"		\
	#--exclude="/.git"									\
	#"$destination"

#--include /home/jb/Desktop   	\
#--include /home/jb/Documents 	\
#--include /home/jb/Downloads 	\
#--include /home/jb/Music     	\
#--include /home/jb/Pictures  	\
#--include /home/jb/Projets   	\
#--include /home/jb/Videos			\

command="$1"

case "$command" in
	games)
		rsync -av "$HOME"/Games "$root/surf-games@arch"
		rsync -av "$HOME"/.var/app/com.valvesoftware.Steam "$root/surf-steam@arch"
		rsync -av "$HOME"/.var/app/com.usebottles.bottles "$root/surf-bottles@arch"
		;;

	containers)
		rsync -av "$HOME"/.local/share/containers "$root/surf-containers@arch"
		rsync -av "$HOME"/.local/libvirt/images "$root/surf-libvirt-images@arch"
		;;

	all)
		rsync -av --delete \
			--exclude="/.git" \
			--exclude="$HOME"/.cache \
			--exclude="$HOME"/.local/share/containers \
			--exclude="$HOME"/.local/share/libvirt/images \
			--exclude="$HOME"/.local/src \
			--exclude="$HOME"/.var/app/com.valvesoftware.Steam \
			--exclude="$HOME"/.var/app/com.usebottles.bottles \
			--exclude="$HOME"/Games \
			/home "$destination"
		;;

esac
