# User specific aliases and functions

# Verbosity
alias ls="ls -hNA --color=auto --group-directories-first"
alias ll="ls -lhFA --color=auto --group-directories-first"
alias cd=cdls
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias mkdir="mkdir -pv"

cdls() { builtin cd $@ && ls; }

alias vim=nvim
alias top=htop
alias diff=colordiff
alias tmux="tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"

alias sensors="watch -n 1 sensors"
alias nvidia-smi-watch="watch -n 1 nvidia-smi"

# working environments
alias notebook="~/Documents/Projects/resources/notebook/notebook.sh"
alias exercism="~/Documents/Projects/exercism/exercism.sh"

# toolboxes comands
alias mix="toolbox --container elixir run mix"

# dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/Documents/Projects/dotfiles --work-tree=$HOME"
