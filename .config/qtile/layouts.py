'''
Custom layouts module
'''

from libqtile import layout

layout_theme = {
        "border_width": 2,
        "margin": 2,
        "border_focus": "999999",
        # "border_normal": "1D2330"
}

layouts = [
    # layout.Stack(num_stacks=2, **layout_theme),
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Floating(**layout_theme),
    layout.TreeTab(**layout_theme)
]

def get():
    '''
    Returns configured layouts
    '''
    return layouts
