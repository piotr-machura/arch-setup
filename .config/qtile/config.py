# ----------------------------------
# QTILE TILING WINDOW MANAGER CONFIG
# ----------------------------------

import subprocess
import re
from libqtile import bar, hook, layout, widget
from libqtile.config import Drag, Click, Group, Key, Screen
from libqtile.lazy import lazy
# pylint: disable=invalid-name,protected-access,line-too-long

# AUTOSTART
# ---------


@hook.subscribe.startup_once
def autostart():
    """List of lists with commands to be executed on startup and their args."""
    processes = [
        ['xrandr', '--size', '1360x768'],
        ['dunst'],
        ['picom', '-b'],
        ['spacefm', '-d'],
        ['light-locker'],
    ]
    for process in processes:
        subprocess.Popen(process)


# KEYBINDINGS
# -----------
win = 'mod4'
shift = 'shift'
ctrl = 'control'

keys = [

    # Switch between windows in current stack pane
    Key([win], 'h', lazy.layout.left()),
    Key([win], 'j', lazy.layout.down()),
    Key([win], 'k', lazy.layout.up()),
    Key([win], 'l', lazy.layout.right()),

    # Move windows up or down in current stack
    Key([win, shift], 'h', lazy.layout.swap_left()),
    Key([win, shift], 'j', lazy.layout.shuffle_down()),
    Key([win, shift], 'k', lazy.layout.shuffle_up()),
    Key([win, shift], 'l', lazy.layout.swap_right()),
    Key([win], 'equal', lazy.layout.grow()),
    Key([win], 'minus', lazy.layout.shrink()),
    Key([win], '0', lazy.layout.normalize()),
    Key([win], 'p', lazy.next_layout()),
    Key([win], 'Return', lazy.spawn('alacritty')),
    Key([win], 'w', lazy.spawn('firefox')),
    Key([win], 'f', lazy.spawn('spacefm')),
    Key([win], 's', lazy.spawn('spotify')),
    Key([win], 'i', lazy.spawn('nm-connection-editor')),
    Key([win], 'space', lazy.spawn('rofi -show drun')),
    Key([win], 'c', lazy.spawn('rofi -show calc -lines 0 -terse -no-history')),
    Key([], 'Print', lazy.spawn('screenshot')),
    Key([shift], 'Print', lazy.spawn('screenshot full')),
    Key([win], 'q', lazy.window.kill()),
    Key([win, ctrl], 'r', lazy.restart()),
    Key([win, ctrl], 'q', lazy.spawn('rofi-powermenu')),
    Key([win], 'Tab', lazy.screen.toggle_group()),
]

mouse = [
    Drag(
        [win],
        'Button1',
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag(
        [win],
        'Button3',
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click(
        [win],
        'Button2',
        lazy.window.toggle_floating()),
]

follow_mouse_focus = False
bring_front_click = True
cursor_warp = True

# GROUPS
# ------

groups = [Group(str(i + 1)) for i in range(5)]

for i in groups:
    keys.extend(
        [
            Key([win],
                i.name,
                lazy.group[i.name].toscreen()),
            Key(
                [win, shift],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
            )
        ]
    )

dgroups_key_binder = None
dgroups_app_rules = []    # type: List

# LAYOUTS
# -------

nord_colors = [
    '#2E3440', '#3b4252', '#434c5e', '#4c566a',
    '#d8dee9', '#e5e9f0', '#eceff4', '#8fbcbb',
    '#88c0d0', '#81a1c1', '#5e81ac', '#bf616a',
    '#d08770', '#ebcb8b', '#a3be8c', '#b48ead',
]

theme_layout = {
    'border_width': 4,
    'margin': 10,
    'border_focus': nord_colors[8],
    'border_normal': nord_colors[3],
}

layouts = [
    layout.MonadTall(
        align=layout.MonadTall._left,
        ratio=0.5,
        max_ratio=0.9,
        min_ratio=0.1,
        change_ratio=0.05,
        single_border_width=theme_layout['border_width'],
        single_margin=theme_layout['margin'],
        name=' ',
        **theme_layout),
    layout.Max(name=' ', **theme_layout),
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
        {'wmclass': 'confirmreset'},    # gitk
        {'wmclass': 'makebranch'},    # gitk
        {'wmclass': 'maketag'},    # gitk
        {'wname': 'branchdialog'},    # gitk
        {'wname': 'pinentry'},    # GPG key password entry
        {'wmclass': 'ssh-askpass'},    # ssh-askpass
    # User-created floating window rules
    # Run `xprop` to see the wm class
        {'wmclass': 'pavucontrol'},
        {'wmclass': 'nm-connection-editor'},
        {'wmclass': 'spotify'},
    ],
    **theme_layout)

auto_fullscreen = True
focus_on_window_activation = 'smart'
wmname = 'Qtile'

# SCREENS & WIDGETS
# -----------------

class PamixerVolume(widget.base._TextBox):
    """Volume widget using the pamixer tool."""

    orientations = widget.base.ORIENTATION_HORIZONTAL
    defaults = [
        ('padding', 3, 'Padding left and right. Calculated if None.'),
        ('update_interval', 0.2, 'Update time in seconds.'),
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(PamixerVolume.defaults)
        self.surfaces = {}
        self.volume = None
        self.mouse_callbacks = {
            'Button1': lambda: subprocess.Popen(['pamixer', '--toggle-mute']),
            'Button3': lambda: subprocess.Popen(['pavucontrol']),
        }

    def timer_setup(self):
        self.update()
        self.timeout_add(self.update_interval, self.update)

    def button_press(self, x, y, button):
        name = f'Button{button}'
        if name in self.mouse_callbacks:
            self.mouse_callbacks[name]()
        self.update()

    @staticmethod
    def get_volume():
        """Use pamixer to find current volume."""
        p_outcome = subprocess.Popen(
            ['pamixer', '--get-volume'], stdout=subprocess.PIPE)
        volume, _ = p_outcome.communicate()
        p_outcome = subprocess.Popen(
            ['pamixer', '--get-mute'], stdout=subprocess.PIPE)
        muted, _ = p_outcome.communicate()
        if 'true' in str(muted):
            return -1
        volume = re.sub(r"[b'\\n]", '', str(volume))
        return int(volume)

    def _update_drawer(self):
        if 0 < self.volume < 30:
            self.text = '奄'
        elif 30 < self.volume <= 70:
            self.text = '奔'
        elif self.volume > 70:
            self.text = '墳'
        else:
            self.text = '婢'

    def update(self):
        vol = self.get_volume()
        if vol != self.volume:
            self.volume = vol
            self._update_drawer()
            self.bar.draw()
        self.timeout_add(self.update_interval, self.update)


widget_defaults = {
    'font': 'NotoSans Nerd Font',
    'padding': 4,
    'foreground': nord_colors[6],
    'markup': True,
    'fontsize': 14,
}

screens = [
    Screen(
        wallpaper='~/.local/share/backgrounds/arch.jpg',
        wallpaper_mode='fill',
        bottom=bar.Bar(
            [
                widget.Spacer(length=5),    # pylint: disable=no-member
                widget.GroupBox(
                    highlight_method='block',
                    active=nord_colors[6],
                    center_aligned=True,
                    disable_drag=True,
                    inactive=nord_colors[3],
                    this_screen_border=nord_colors[0],
                    this_current_screen_border=nord_colors[10],
                    urgent_border=nord_colors[12],
                    use_mouse_wheel=False,
                    rounded=False,
                    margin_y=4,
                    padding_y=10,
                ),
                widget.Spacer(length=5),    # pylint: disable=no-member
                widget.WindowName(show_state=False),
                PamixerVolume(
                    fontsize=18,
                    update_interval=2.5,
                    padding=6,
                ),
                widget.CurrentLayout(),
                widget.Clock(format='%H:%M'),
                widget.Spacer(length=5),    # pylint: disable=no-member
            ],
            36,
            background=nord_colors[0]),
    ),
]
