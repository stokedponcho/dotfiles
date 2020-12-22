# .profile

# User directories
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export SCRIPTS="$HOME/.local/scripts"

# Adds `~/.local/script/bin` to $PATH
! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]] && export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
! [[ "$PATH" =~ "$XDG_DATA_HOME/cargo/bin" ]] && export PATH="$XDG_DATA_HOME/cargo/bin:$PATH"
! [[ "$PATH" =~ "$SCRIPTS/bin" ]] && export PATH="$PATH:$(du "$SCRIPTS/bin" | cut -f2 | paste -sd ':')"

# Default programs:
export BROWSER="firefox"
export EDITOR="nvim"
export PAGER="less"
export TERMINAL="st"
export WM="bspwm"
export LAUNCHER="dmenu_run"
export LAUNCHER_ALT="rofi -show combi"

# global program settings
export QT_QPA_PLATFORMTHEME="gtk3"
export SKIM_DEFAULT_OPTIONS="--height 40% --reverse"
export _Z_DATA="$XDG_DATA_HOME/z"

# Clean up ~:
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HEX_HOME="$XDG_DATA_HOME/hex"
export HISTFILE="$XDG_DATA_HOME/bash_history"
export INPUTRC="$XDG_CONFIG_HOME/bash/inputrc"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export LESSHISTFILE=-
export MIX_HOME="$XDG_DATA_HOME/mix"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYTHONHISTORY="$XDG_DATA_HOME/python_history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export SSH_ASKPASS="/usr/lib/ssh/ssh-askpass"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

[ -f $HOME/.bashrc ] && . $HOME/.bashrc
[ -f "$XDG_CONFIG_HOME/profile_secrets" ] && . $XDG_CONFIG_HOME/profile_secrets
[ -f "$XDG_CONFIG_HOME/lf/icons.sh" ] && . $XDG_CONFIG_HOME/lf/icons.sh

# Start WM
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep "$WM" || startx "$XDG_CONFIG_HOME/X11/xinitrc"
fi
