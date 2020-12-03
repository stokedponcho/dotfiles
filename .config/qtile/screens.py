'''
Custom screens configuration.
'''
from libqtile import bar, widget
from libqtile.config import Screen

import arcobattery
import env

MONITOR_COUNT = 2
ICON_THEME_PATH = "/usr/share/icons/AwOkenDark/clear/24x24/status/"
BATTERY_ICONS = f"{env.CONFIG_HOME}/qtile/icons/battery_icons_horiz"

def get():
    '''
    Returns Screens configuration
    '''
    return [_get_default_screen() for _ in range(1, MONITOR_COUNT + 1)]


def _get_default_screen():
    return Screen(
        top=bar.Bar(
            [
                widget.Sep(linewidth=0, padding=6),
                widget.GroupBox(
                    margin_y=3,
                    margin_x=0,
                    padding_y=5,
                    padding_x=3,
                    borderwidth=3,
                    rounded=False,
                    highlight_method="line",
                ),
                widget.Sep(linewidth=0, padding=6),
                widget.CurrentLayoutIcon(scale=0.5),
                widget.CurrentLayout(),
                widget.Sep(linewidth=0, padding=40),
                widget.WindowName(),
                widget.Notify(),
                widget.Systray(),
                widget.ThermalSensor(
                    treshold=70,
                    foreground='808080',
                    update_interval=5),
                widget.Memory(update_interval=5.0),
                # widget.Volume(),
                # widget.BatteryIcon(theme_path=ICON_THEME_PATH),
                widget.Clock(format='%A, %B %d %H:%M'),
                arcobattery.BatteryIcon(
                    padding=0,
                    scale=0.6,
                    y_poss=3,
                    update_interval=60,
                    theme_path=BATTERY_ICONS,
                    ),
            ],
            30,
            opacity=0.8
        ),
    )

def _separator():
    return widget.TextBox(
        text='',
        padding=0,
        fontsize=24,
    )
