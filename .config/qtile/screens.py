'''
Custom screens configuration.
'''
import os
import socket

from libqtile import bar, widget
from libqtile.config import Screen

MONITOR_COUNT = 2

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
                    # active=colors[2],
                    # inactive=colors[2],
                    rounded=False,
                    # highlight_color=colors[1],
                    highlight_method="line",
                    # this_current_screen_border=colors[3],
                    # this_screen_border=colors [4],
                    # other_current_screen_border=colors[0],
                    # other_screen_border=colors[0],
                    # foreground=colors[2],
                    # background=colors[0]
                ),
                widget.Prompt(
                    prompt=prompt,
                    font="Hack Regular",
                    padding=10
                ),
                widget.Sep(linewidth=0, padding=40),
                widget.WindowName(),
                widget.Systray(),
                _arrow(),
                widget.CurrentLayoutIcon(scale=0.5),
                widget.CurrentLayout(),
                _arrow(),
                widget.TextBox(text='🌡', padding=2),
                widget.ThermalSensor(treshold=70, foreground='808080', update_interval=5),
                widget.TextBox(text='🖬'),
                widget.Memory(update_interval=5.0),
                # widget.Net(interface="wlp59s0"),
                _arrow(),
                widget.Clock(format='%A, %B %d %H:%M'),
                _arrow(),
                widget.Volume(),
                _arrow(),
                widget.Battery(
                    show_short_text=False,
                    format="{char} {percent:2.0%}",
                    full_char=''),
                widget.Sep(linewidth=0),
            ],
            24,
        ),
    )

def _arrow():
    return widget.TextBox(
        text='',
        # background=colors[0],
        # foreground=colors[4],
        padding=0,
        fontsize=24,
    )
