# README.md

## GNU Stow

The various configuration files in this repository are managed using GNU Stow. Symlinks for all of dotfiles can be setup as follow:

```sh
git clone <repo> ~/.dotfiles

stow .
```

## Tracking dotfiles directly with Git

[https://news.ycombinator.com/item?id=11071754]

```sh
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

```sh
git clone --separate-repo $HOME/.dotfiles
```

## Miscellaneous

### Pulseaudio

```sh
pacman -S pulseaudio pulseaudio-alsa pulsemixer pavucontrol
```

### bspwn

```sh
pacman -S bspwm sxhkd
yay -S polybar
```

### podman

<https://wiki.archlinux.org/index.php/Podman>

```sh
pacman -S podman buildah crun
usermod --add-subuids 165536-231072 --add-subgids 165536-231072 $(whoami)
```

#### Switching to cgroups v2

```sh
# visudo /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="systemd.unified_cgroup_hierarchy=1"

# grub-mkconfig -o /boot/grub/grub.cfg
```

### other

```sh
xrandr --output eDP1 --auto --scale 1.0x1.0 --output DP3 --auto --right-of eDP1
```

```sh
pacman -S xorg-xsetroot
pacman -S redshift
pacman -S dash checkbashisms
pacman -S cronie
```

```sh
paru -S xmenu xdg-xmenu-git
```
