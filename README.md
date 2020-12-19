# README.md

## Pulseaudio

```
pacman -S pulseaudio pulseaudio-alsa pulsemixer pavucontrol
```

## bspwn

```
pacman -S bspwm sxhkd
yay -S polybar
```

## podman

<https://wiki.archlinux.org/index.php/Podman>

```
pacman -S podman buildah crun
usermod --add-subuids 165536-231072 --add-subgids 165536-231072 $(whoami)
```

### Switching to cgroups v2

```
# visudo /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="systemd.unified_cgroup_hierarchy=1"

# grub-mkconfig -o /boot/grub/grub.cfg
```

## other

```
xrandr --output eDP1 --auto --scale 1.0x1.0 --output DP3 --auto --right-of eDP1
```

```
pacman -S xorg-xsetroot
pacman -S redshift
pacman -S dash checkbashisms
pacman -S cronie
```
