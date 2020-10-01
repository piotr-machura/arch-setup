# ----------------------------------
# QTILE TILING WINDOW MANAGER CONFIG
# ----------------------------------

import subprocess
from typing import List  # noqa: F401
import re
from libqtile import bar, hook, layout, widget
from libqtile.config import Drag, Click, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
#pylint: disable=invalid-name

# AUTOSTART
# ---------
@hook.subscribe.startup_once
def autostart():
    """List of lists with commands to be executed on startup and their args"""
    processes = [
        ['xrandr', '--size', '1360x768'],
        ['dunst', '&'],
        ['picom', '-b']
    ]
    for process in processes:
        subprocess.Popen(process)

terminal = guess_terminal()


# KEYBINDINGS
# -----------

mod = "mod4"
scrot = "scrot --select --freeze --line style=solid,width=3,color=#a3be8"
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
    Key([mod], "f", lazy.spawn("alacritty -e ranger")),
    Key([mod], "s", lazy.spawn("spotify")),
    Key([mod], "space", lazy.spawn("rofi -show drun")),
    Key([], "Print", lazy.spawn(scrot)),
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
bring_front_click = True
cursor_warp = True

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
    "margin" : 15,
    "border_focus" : nord_colors[9],
    "border_normal" : nord_colors[3]
}

layouts = [
    layout.MonadTall(
        align = layout.MonadTall._left, #pylint: disable=protected-access
        ratio = 0.5,
        max_ratio = 0.75,
        min_ratio = 0.25,
        change_ratio = 0.05,
        single_border_width = theme_layout["border_width"],
        single_margin = theme_layout["margin"],
        name = ' ',
        **theme_layout
    ),
    layout.Max(
        name = ' ',
        **theme_layout
    ),
]

floating_layout = layout.Floating(
    float_rules=[
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
        # User-created floating window rules
        # Run `xprop` to see the wm class
        {'wmclass': 'galculator'},
        {'wmclass': 'pavucontrol'},
        {'wmclass': 'nm-connection-editor'},
        {'wmclass': 'spotify'},
    ],
    **theme_layout
)

auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"

# SCREENS & WIDGETS
# -----------------

class PamixerVolume(widget.base._TextBox): # pylint: disable=protected-access
    """Volume widget using the pamixer cli tool"""
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
            'Button1': lambda: subprocess.Popen(["pamixer", "--toggle-mute"]),
            'Button3': lambda: subprocess.Popen(["pavucontrol"]),
        }

    def timer_setup(self):
        self.timeout_add(self.update_interval, self.update)

    def button_press(self, x, y, button):
        name = f'Button{button}'
        if name in self.mouse_callbacks:
            self.mouse_callbacks[name]()
        self._update_drawer()
        self.draw()

    @staticmethod
    def get_volume():
        """Use pamixer to find current volume"""
        p_outcome = subprocess.Popen(
            ["pamixer","--get-volume"],
            stdout=subprocess.PIPE)
        volume, _= p_outcome.communicate()
        p_outcome = subprocess.Popen(
            ["pamixer","--get-mute"],
            stdout=subprocess.PIPE)
        muted, _ = p_outcome.communicate()
        if "true" in str(muted):
            return -1
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
        """Called every update_interval"""
        vol = self.get_volume()
        if vol != self.volume:
            self.volume = vol
            self._update_drawer()
            self.bar.draw()
        self.timeout_add(self.update_interval, self.update)

theme_widget = {
    "font" : 'NotoSans Nerd Font',
    "padding" : 4,
    "foreground" : nord_colors[6],
    "markup": True,
    "fontsize": 14
}

screens = [
    Screen(
        wallpaper='/usr/share/backgrounds/iceberg.jpg',
        wallpaper_mode='fill',
        bottom=bar.Bar(
            [
                widget.Spacer(length = 5), # pylint: disable=no-member
                widget.GroupBox(
                    highlight_method ='block',
                    active = nord_colors[6],
                    center_aligned = True,
                    disable_drag = True,
                    inactive = nord_colors[3],
                    this_screen_border = nord_colors[0],
                    this_current_screen_border = nord_colors[10],
                    urgent_border = nord_colors[12],
                    use_mouse_wheel = False,
                    rounded = False,
                    margin_y = 4,
                    padding_y = 10,
                    **theme_widget
                ),
                widget.Spacer(length=5), # pylint: disable=no-member
                widget.WindowName(
                    show_state = False,
                    **theme_widget
                ),
                PamixerVolume(
                    fontsize=19,
                    font=theme_widget['font'],
                    foreground=theme_widget['foreground'],
                    padding=theme_widget['padding'],
                ),
                widget.CurrentLayout(**theme_widget),
                widget.Clock(format='%H:%M', **theme_widget),
                widget.Spacer(length=5), # pylint: disable=no-member
            ],
            36,
            background = nord_colors[0]
        ),
    ),
]
