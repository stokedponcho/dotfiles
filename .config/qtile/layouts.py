'''
Custom layouts module
'''

from libqtile import layout

layout_theme = {
        "border_width": 2,
        "margin": 6,
        "border_focus": "888888",
        # "border_normal": "1D2330"
}

layouts = [
    # layout.Stack(num_stacks=2, **layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme),
    layout.TreeTab(**layout_theme)
]

def get():
    '''
    Returns configured layouts
    '''
    return layouts
