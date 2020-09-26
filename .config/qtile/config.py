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
import re

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
        ['dunst', '&'],
        ['picom', '&']
    ]
    for process in processes:
        subprocess.Popen(process)

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
        {'wmclass': 'spotify'},
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
    def _configure(self, *args, **kwargs):
        super()._configure(*args, **kwargs)
        self._name_to_icon(self.bar.screen.group.layouts[0].name)

    def _name_to_icon(self, name):
        if name == 'monadtall':
            self.text = " "
        elif name == 'max':
            self.text = " "
        elif name == 'floating':
            self.text = " "
        else:
            self.text = name

    def setup_hooks(self):
        def hook_response(layout, group):
            if group.screen is not None \
                    and group.screen == self.bar.screen:
                self._name_to_icon(layout.name)
                self.bar.draw()
        hook.subscribe.layout_change(hook_response)

class PamixerVolume(widget.base._TextBox):
    orientations = widget.base.ORIENTATION_HORIZONTAL
    defaults = [
        ("padding", 3, "Padding left and right. Calculated if None."),
        ("update_interval", 0.2, "Update time in seconds."),
        ]
    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(PamixerVolume.defaults)
        self.surfaces = {}
        self.volume = None
        self.mouse_callbacks = {
            'Button1': self.cmd_mute,
            'Button3': self.cmd_app,
        }

    def timer_setup(self):
        self.timeout_add(self.update_interval, self.update)

    def button_press(self, x, y, button):
        name = 'Button{0}'.format(button)
        if name in self.mouse_callbacks:
            self.mouse_callbacks[name]()
        self.draw()
        self._update_drawer()

    def get_volume(self):
        p = subprocess.Popen(["pamixer","--get-volume"], stdout=subprocess.PIPE)
        volume, _= p.communicate()
        p = subprocess.Popen(["pamixer","--get-mute"], stdout=subprocess.PIPE)
        muted, _ = p.communicate()
        if "true" in str(muted):
            return -1
        else:
            volume = re.sub(r"[b'\\n]", "", str(volume))
            return int(volume)

    def _update_drawer(self):
        if 0 < self.volume < 30:
            self.text = '奄 '
        elif 30 < self.volume <= 70:
            self.text = '奔 '
        elif self.volume > 70:
            self.text = '墳 '
        else:
            self.text = ' ﱝ  '

    def update(self):
        vol = self.get_volume()
        if vol != self.volume:
            self.volume = vol
            # Update the underlying canvas size before actually attempting
            # to figure out how big it is and draw it.
            self._update_drawer()
            self.bar.draw()
        self.timeout_add(self.update_interval, self.update)

    def cmd_mute(self):
        subprocess.Popen(["pamixer", "--toggle-mute"])

    def cmd_app(self):
        subprocess.Popen(["pavucontrol"])

theme_widget = {
    "font" : 'NotoSans Nerd Font',
    "padding" : 5,
    "foreground" : nord_colors[6],
    "markup": True,
}

screens = [
    Screen(
        wallpaper='/usr/share/backgrounds/iceberg.jpg',
        wallpaper_mode='fill',
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    active = nord_colors[6],
                    fontsize = 12,
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
                widget.WindowName(
                    fontsize=12,
                    show_state = False,
                    fmt='<b> {} </b>',
                    **theme_widget
                ),
                PamixerVolume(
                    fontsize=14,
                    **theme_widget,
                ),
                NERDLayout(fontsize=12,**theme_widget),
                widget.Clock(fontzise=12, format='%H:%M', **theme_widget),
            ],
            30,
            background = nord_colors[0]
        ),
    ),
]
