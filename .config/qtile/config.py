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
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
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

import subprocess
from typing import List  # noqa: F401
from time import sleep

from libqtile import bar, hook, layout, widget
from libqtile.config import Drag, Click, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# AUTOSTART
# ---------
@hook.subscribe.startup_once
def autostart():
    """List of lists with commands to be executed on startup and their args"""
    processes = [
        ['xrandr', '--size', '1360x768'],
    ]
    for process in processes:
        subprocess.Popen(process)
    sleep(0.1)
    lazy.refresh()

terminal = guess_terminal()


# KEYBINDINGS
# -----------

mod = "mod4"
keys = [
    # Switch between windows in current stack pane
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "l", lazy.layout.right()),

    # Move windows up or down in current stack
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),

    Key([mod], "equal", lazy.layout.grow()),
    Key([mod], "minus", lazy.layout.shrink()),
    Key([mod], "0", lazy.layout.normalize()),
    Key([mod], "p", lazy.next_layout()),

    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "w", lazy.spawn("firefox")),
    Key([mod], "f", lazy.spawn("thunar")),
    Key([mod], "s", lazy.spawn("spotify")),
    Key([mod], "space", lazy.spawn("rofi -show drun")),

    Key([mod], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod],"Button2", lazy.window.toggle_floating())
]

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

# GROUPS
# ------

groups = [Group(str(i+1)) for i in range(5)]

for i in groups:
    keys.extend([
        Key([mod], i.name,
            lazy.group[i.name].toscreen()),
        Key([mod, "shift"], i.name,
            lazy.window.togroup(i.name, switch_group=True)),
    ])

keys.append(Key([mod], "Tab", lazy.screen.toggle_group()))

dgroups_key_binder = None
dgroups_app_rules = []  # type: List

# LAYOUTS
# -------

nord_colors = [
    '#2E3440',
    '#3b4252',
    '#434c5e',
    '#4c566a',
    '#d8dee9',
    '#e5e9f0',
    '#eceff4',
    '#8fbcbb',
    '#88c0d0',
    '#81a1c1',
    '#5e81ac',
    '#bf616a',
    '#d08770',
    '#ebcb8b',
    '#a3be8c',
    '#b48ead',
]

theme_layout = {
    "border_width" : 2,
    "margin" : 10,
    "border_focus" : nord_colors[9],
    "border_normal" : nord_colors[3]
}

layouts = [
    layout.MonadTall(
        align = layout.MonadTall._left,
        single_border_width = theme_layout["border_width"],
        single_margin = theme_layout["margin"],
        ratio = 0.5,
        max_ratio = 0.75,
        min_ratio = 0.25,
        change_ratio = 0.05,
        **theme_layout
    ),
    layout.Max(**theme_layout),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run `xprop` to see the wm class and name of an X client.
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
    ],
    **theme_layout
)

auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"

# SCREENS & WIDGETS
# -----------------

class NERDLayout(widget.CurrentLayout):
    """CurrentLayout widget with NERD font icons instead of names"""
    def setup_hooks(self):
        def hook_response(layout, group):
            if group.screen is not None \
                    and group.screen == self.bar.screen:
                if layout.name == 'monadtall':
                    self.text = " "
                elif layout.name == 'max':
                    self.text = " "
                elif layout.name == 'floating':
                    self.text = " "
                else:
                    self.text = layout.name
                self.bar.draw()
        hook.subscribe.layout_change(hook_response)

theme_widget = {
    "font" : 'NotoSans Nerd Font',
    "fontsize" : 12,
    "padding" : 5,
    "foreground" : nord_colors[6],
    "markup": True,
    "fmt" : '<b> {} </b>'
}

screens = [
    Screen(
        wallpaper='/usr/share/backgrounds/iceberg.jpg',
        wallpaper_mode='fill',
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    active = nord_colors[6],
                    borderwidth = 2,
                    center_aligned = True,
                    disable_drag = True,
                    inactive = nord_colors[3],
                    margin_y = 3,
                    margin_x = 5,
                    padding_x = theme_widget["padding"],
                    padding_y = 1,
                    this_screen_border = nord_colors[0],
                    this_current_screen_border = nord_colors[10],
                    urgent_border = nord_colors[11],
                    urgent_text = nord_colors[11],
                    use_mouse_wheel = False,
                    rounded = False,
                    **theme_widget
                ),
                widget.WindowName(**theme_widget),
                NERDLayout(**theme_widget),
                widget.Clock(format='%H:%M', **theme_widget),
            ],
            30,
            background = nord_colors[0]
        ),
    ),
]
