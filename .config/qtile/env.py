import os

CONFIG_HOME = os.getenv("XDG_CONFIG_HOME", os.environ["HOME"] + "/.config")
TERMINAL = os.getenv("TERMINAL", "st")
