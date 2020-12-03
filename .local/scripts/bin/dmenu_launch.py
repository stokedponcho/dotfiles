#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""\
Customized and heavily stripped version of dmenu-launch to start flatpak applications from dmenu.

Orignal Contact / Links
---------------
author : Felipe Silveira <felipe.alexandre@gmail.com>
link   : https://github.com/fsilveir/dmenu-launch

"""
import os
import subprocess
import sys
from distutils.spawn import find_executable

APPLICATIONS_SUFFIX = ".desktop"
APPLICATIONS_DIRECTORIES = [
        "/usr/share/applications",
        "/var/lib/flatpak/exports/share/applications"
    ]

def main():
    check_req_utils()
    args = sys.argv[1:]
    choice = dmenu_input(args)
    take_action(choice)

def check_req_utils():
    """Checks if dmenu and other mandatory utilities can be found on target machine."""
    utils = (['dmenu', 'gtk-launch'])
    for util in utils:
        if find_executable(util) is None:
            print(f"ERROR: Util '{util}' is missing, install it before proceeding! Exiting!")
            sys.exit(1)

def check_dir_exist(scheme):
    """Checks required directories are present."""
    if os.path.exists(scheme.prefix) is False:
        print("ERROR: Required directory '{}' is missing! Exiting!".format(scheme.prefix))
        sys.exit(1)

def dmenu_input(args):
    """Builds dmenu list of options and returns the value selected by user."""
    choices = dict()
    for directory in APPLICATIONS_DIRECTORIES:
        for _, _, files in os.walk(directory, followlinks=True):
            options = [(f.replace(APPLICATIONS_SUFFIX, '', -1), directory)
                       for f in files if f.endswith(APPLICATIONS_SUFFIX)]
            choices = dict(choices, **dict(options))

    dmenu_executable = "dmenu"
    dmenu = subprocess.Popen([dmenu_executable] + args,
                             stdin=subprocess.PIPE,
                             stderr=subprocess.PIPE,
                             stdout=subprocess.PIPE)

    choice_lines = '\n'.join(map(str, sorted(choices)))
    choice, errors = dmenu.communicate(choice_lines.encode('utf-8'))

    if dmenu.returncode not in [0, 1] \
       or (dmenu.returncode == 1 and len(errors) != 0):
        print("'{} {}' returned {} and error:\n{}"
              .format(['dmenu'], ' '.join(args), dmenu.returncode,
                      errors.decode('utf-8')))
        sys.exit(1)

    choice = choice.decode('utf-8').rstrip()

    return (choices[choice], choice + APPLICATIONS_SUFFIX) if choice in choices else sys.exit(1)


def take_action(choice):
    """ Launches app. """
    run_subprocess('cd "{}" && gtk-launch "{}"'.format(choice[0], choice[1]))

def run_subprocess(cmd):
    """Handler for shortening subprocess execution."""
    subprocess.Popen(cmd,
                     stdin=subprocess.PIPE,
                     stderr=subprocess.PIPE,
                     stdout=subprocess.PIPE,
                     shell=True)

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
