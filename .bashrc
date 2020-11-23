# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

# User specific environment and startup programs

# Default programs:
export BROWSER="firefox"
export EDITOR="nvim"
export TERMINAL="st"

# Clean up ~:
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# Secrets
[[ -f $HOME/.bash_secrets ]] && source $HOME/.bash_secrets

#
# pywal
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)
# To add support for TTYs this line can be optionally added.
source "${XDG_CACHE_HOME:-$HOME/.cache}/wal/colors-tty.sh"

# custom prompt:
#export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] "
export PS1="\[\033[01;34m\]\w \[\033[01;32m\]\$\[\033[00m\] "
