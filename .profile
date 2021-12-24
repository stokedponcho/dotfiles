# .profile

# User directories
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export XDG_MENU_ITEMS="$HOME/.cache/xdg-xmenu/items"
export SCRIPTS="$HOME/.local/scripts"

# Default programs:
export BROWSER="firefox"
export BROWSER_CLI="w3m"
export EDITOR="nvim"
export GIT_EDITOR="$EDITOR"
export LAUNCHER="dmenu_run"
export LAUNCHER_ALT="rofi -show combi"
export LOCKER="slock"
export PAGER="less --quit-if-one-screen"
export TERMINAL="st"
#export VISUAL="emacsclient -nc"
export WM="bspwm"
#export WM="awesome"

# global program settings
export CM_IGNORE_WINDOW="KeePassXC"
export DOOMDIR="$HOME/.config/doom"
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export FZF_DEFAULT_OPTS="--height=40% --reverse"
export QT_QPA_PLATFORMTHEME="gtk3"
export SKIM_DEFAULT_OPTIONS="--height 40% --reverse"
export _Z_DATA="$XDG_DATA_HOME/z"
export _ZL_DATA="$XDG_DATA_HOME/z"

# Clean up ~:
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnetcli"
export GOPATH="$XDG_DATA_HOME/go"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HEX_HOME="$XDG_DATA_HOME/hex"
export HISTFILE="$XDG_DATA_HOME/bash_history"
export INPUTRC="$XDG_CONFIG_HOME/bash/inputrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export LESSHISTFILE=-
export MIX_HOME="$XDG_DATA_HOME/mix"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NUGET_PACKAGES="$XDG_CACHE_HOME/nuget"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYTHONHISTORY="$XDG_DATA_HOME/python_history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export SSH_ASKPASS="/usr/lib/ssh/ssh-askpass"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

# Adds ~/.local/scripts/bin to $PATH
export PATH="$(find "$SCRIPTS"/bin -type d | paste -sd ':'):$PATH"

# Adds custom bin paths to $PATH
! [[ "$PATH" =~ "$HOME"/.local/bin:"$HOME"/bin: ]] && export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
! [[ "$PATH" =~ "$CARGO_HOME"/bin ]] && export PATH="$CARGO_HOME/bin:$PATH"
! [[ "$PATH" =~ "$HOME"/.local/src/adr-tools/src ]] && export PATH="$HOME/.local/src/adr-tools/src:$PATH"

[ -f "$XDG_CONFIG_HOME"/lf/icons.sh ] && source "$XDG_CONFIG_HOME/lf/icons.sh"

[ -f "$HOME"/.bashrc ] && . "$HOME/.bashrc"
[ -f "$XDG_CONFIG_HOME"/profile_secrets ] && source "$XDG_CONFIG_HOME/profile_secrets"

pgrep ssh-agent || eval "$(ssh-agent)"

# Start WM
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null 2>&1 && exec startx "$XINITRC"
