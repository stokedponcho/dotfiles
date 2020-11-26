# .profile

# User dir
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Adds `~/.local/bin` to $PATH
#export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"


[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.config/profile_secrets ]] && . ~/.config/profile_secrets

# Default programs:
export BROWSER="firefox"
export EDITOR="nvim"
export PAGER="less"
export TERMINAL="st"
export WM="qtile"

# Clean up ~:
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export LESSHISTFILE=-
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
#export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
#export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

# start WM
#if [[ "$(tty)" = "/dev/tty1" ]]; then
	#pgrep "$WM" || startx "$XDG_CONFIG_HOME/X11/xinitrc"
#fi
