# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, MODify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from typing import List  # noqa: F401

from libqtile import hook, layout
from libqtile.command import lazy
from libqtile.config import Click, Drag, Group, Key

import gnome_qtile
import layouts
import screens

ALT = "mod1"
MOD = "mod4"    # sets MOD key to SUPER/WINDOWS
TERM = "st"     # termimal of choice

keys = [
    # Switch between windows in current stack pane
    Key([MOD], "j", lazy.layout.down()),
    Key([MOD], "k", lazy.layout.up()),

    # Switch window focus to other screen
    Key([MOD], "Tab", lazy.next_screen()),

    Key([MOD], "Return", lazy.spawn(TERM)),

    # Toggle between different layouts as defined below
    Key([MOD, "shift"], "Tab", lazy.next_layout()),
    Key([MOD], "w", lazy.window.kill()),

    Key([MOD], "r", lazy.spawn("dmenu_run")),
    # Customised dmenu_launch script for flatpak applications
    Key([MOD, "shift"], "r", lazy.spawn("dmenu_launch")),

    Key([MOD, "control"], "r", lazy.restart()),
    Key([MOD, "control"], "q", lazy.shutdown()),

    Key([MOD], "l", lazy.spawn("light-locker-command -l")),

    # Key([MOD, 'control'], 'l', lazy.spawn('gnome-screensaver-command -l')),
    # Key([MOD, 'control'], 'q', lazy.spawn('gnome-session-quit --logout --no-prompt')),
    # Key([MOD, 'shift', 'control'], 'q', lazy.spawn('gnome-session-quit --power-off')),
]

groups = [Group(i) for i in "asdf"]

for i in groups:
    keys.extend([
        # MOD1 + letter of oup = switch to group
        Key([MOD], i.name, lazy.group[i.name].toscreen()),

        # MOD1 + shift + letter of group = switch to & move focused window to group
        Key([MOD, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

layouts = layouts.get()

widget_defaults = dict(
    font='Hack Bold',
    foreground='808080',
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = screens.get()

# Drag floating layouts.
mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([MOD], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

@hook.subscribe.startup_once
def start_once():
    config = os.getenv("XDG_CONFIG_HOME", os.environ["HOME"] + '/.config')
    subprocess.call([config + '/qtile/autostart.sh'])

@hook.subscribe.startup
def gnome_session():
    gnome_qtile.dbus_register()

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"