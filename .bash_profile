# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
[[ -z $TMUX ]] && setbg # set new wallpaper and associated color scheme
