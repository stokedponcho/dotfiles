'''
    Allows for running of Qtile inside Gnome.
'''

import os
import subprocess

from libqtile import hook


@hook.subscribe.startup
def dbus_register():
    '''
    Registers Qtile with gnome-session.
    '''

    id = os.environ.get('DESKTOP_AUTOSTART_ID')
    if not id:
        return
    subprocess.Popen(['dbus-send',
                      '--session',
                      '--print-reply',
                      '--dest=org.gnome.SessionManager',
                      '/org/gnome/SessionManager',
                      'org.gnome.SessionManager.RegisterClient',
                      'string:qtile',
                      'string:' + id])
