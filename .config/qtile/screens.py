'''
Custom screens configuration.
'''
import os
import socket

from libqtile import bar, widget
from libqtile.config import Screen

MONITOR_COUNT = 2
ICON_THEME_PATH = "/usr/share/icons/AwOkenDark/clear/24x24/status/"

def get():
    '''
    Returns Screens configuration
    '''
    return [_get_default_screen() for _ in range(1, MONITOR_COUNT + 1)]


def _get_default_screen():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

    return Screen(
        top=bar.Bar(
            [
                widget.Sep(linewidth=0, padding=6),
                widget.GroupBox(
                    font="Hack Bold",
                    margin_y=3,
                    margin_x=0,
                    padding_y=5,
                    padding_x=3,
                    borderwidth=3,
                    rounded=False,
                    highlight_method="line",
                ),
                widget.CurrentLayoutIcon(scale=0.5),
                widget.CurrentLayout(),
                widget.Sep(linewidth=0, padding=40),
                widget.WindowName(),
                widget.Notify(),
                widget.Systray(),
                widget.TextBox(text='🌡', padding=2),
                widget.ThermalSensor(treshold=70, foreground='808080', update_interval=5),
                widget.TextBox(text='🖬'),
                widget.Memory(update_interval=5.0),
                widget.Volume(theme_path=ICON_THEME_PATH),
                widget.BatteryIcon(theme_path=ICON_THEME_PATH),
                widget.Clock(format='%A, %B %d %H:%M'),
            ],
            30,
        ),
    )

def _separator():
    return widget.TextBox(
        text='',
        padding=0,
        fontsize=24,
    )
