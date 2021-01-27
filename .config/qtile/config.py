# ----------------------------------
# QTILE TILING WINDOW MANAGER CONFIG
# ----------------------------------

import subprocess
import re
from libqtile import bar, hook, layout, widget
from libqtile.config import Drag, Click, Group, Key, Screen
from libqtile.lazy import lazy
# pylint: disable=invalid-name,protected-access,line-too-long,no-member

wmname = 'Qtile'


# AUTOSTART
# ---------
@hook.subscribe.startup_once
def autostart():
    """List of lists with commands to be executed on startup and their args."""
    processes = [
        ['dunst'],
        ['picom', '-b'],
        ['spacefm', '--daemon-mode'],
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
    # Resize and change layouts
    Key([win], 'p', lazy.next_layout()),
    Key([win], 'o', lazy.window.toggle_minimize()),
    Key([win], 'equal', lazy.layout.grow()),
    Key([win], 'minus', lazy.layout.shrink()),
    Key([win], 'Tab', lazy.screen.toggle_group()),
    # Program shortcuts
    Key([win], 'Return', lazy.spawn('alacritty')),
    Key([win], 'w', lazy.spawn('firefox')),
    Key([win], 'f', lazy.spawn('spacefm')),
    Key([win], 'space', lazy.spawn('rofi -show drun')),
    Key([win], 'c', lazy.spawn('rofi -show calc -lines 0 -terse -no-history')),
    Key([], 'Print', lazy.spawn('screenshot')),
    Key([shift], 'Print', lazy.spawn('screenshot full')),
    # System shortcuts
    Key([win], 'q', lazy.window.kill()),
    Key([win, ctrl], 'r', lazy.restart()),
    Key([win, ctrl], 'q', lazy.spawn('rofi-powermenu')),
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
        start=lazy.window.get_size(),
    ),
    Click(
        [win],
        'Button2',
        lazy.window.toggle_floating(),
    ),
]

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False

# GROUPS
# ------
groups = [Group(str(i + 1)) for i in range(5)]

for i in groups:
    keys.extend(
        [
            Key([win], i.name, lazy.group[i.name].toscreen()),
            Key(
                [win, shift],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
            )
        ])

# LAYOUTS
# -------
nord_colors = [
    '#2e3440',
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
    'border_width': 8,
    'margin': 10,
    'border_focus': nord_colors[9],
    'border_normal': nord_colors[3],
}

layouts = [
    layout.MonadTall(
        align=layout.MonadTall._left,
        new_at_current=False,
        ratio=0.5,
        max_ratio=0.9,
        min_ratio=0.1,
        change_ratio=0.05,
        single_border_width=theme_layout['border_width'],
        single_margin=theme_layout['margin'],
        name='\uf0db ',
        **theme_layout),
    layout.Max(name='\ue25d ', **theme_layout),
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
        {'wmclass': 'gsimplecal'},
        {'wmclass': 'Places'},    # Firefox history/downloads
    ],
    **theme_layout)

auto_fullscreen = True
focus_on_window_activation = 'smart'


# SCREENS & WIDGETS
# -----------------
class PamixerVolume(widget.textbox.TextBox):
    """Volume widget using the pamixer tool."""
    def __init__(self, **config):
        super().__init__(**config)
        self.volume = None

    def timer_setup(self):
        self.update(self.text)
        self.timeout_add(self.update_interval, self.update)

    def button_press(self, x, y, button):
        super().button_press(x, y, button)
        self.update()

    def update(self, text=None):
        """Update volume information and display"""
        p_outcome = subprocess.Popen(
            ['pamixer', '--get-volume'], stdout=subprocess.PIPE)
        pamixer_volume, _ = p_outcome.communicate()
        p_outcome = subprocess.Popen(
            ['pamixer', '--get-mute'], stdout=subprocess.PIPE)
        muted, _ = p_outcome.communicate()
        if 'true' in str(muted):
            vol = -1
        else:
            vol = int(re.sub(r"[b'\\n]", '', str(pamixer_volume)))
        if vol != self.volume:
            self.volume = vol
            if 0 < self.volume <= 15:
                self.text = '\ufa7e'
            elif 15 < self.volume < 50:
                self.text = '\ufa7f'
            elif self.volume >= 50:
                self.text = '\ufa7d'
            else:
                self.text = '\ufc5d'
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
        wallpaper='~/.local/share/backgrounds/mountains.jpg',
        wallpaper_mode='fill',
        bottom=bar.Bar(
            [
                widget.Spacer(length=8),
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
                    padding_x=8,
                ),
                widget.Spacer(length=6),
                widget.Sep(size_percent=65, linewidth=2),
                widget.Spacer(length=6),
                widget.TaskList(
                    highlight_method='block',
                    title_width_method='uniform',
                    rounded=False,
                    markup_focused='{}',
                    markup_floating='\uf0d8  {}',
                    markup_minimized='\uf0d7  {}',
                    border=nord_colors[3],
                    urgent_border=nord_colors[12],
                    spacing=0,
                    margin_y=-1,
                    padding_x=16,
                    padding_y=8,
                    icon_size=0,
                    max_title_width=350,
                ),
                PamixerVolume(
                    fontsize=18,
                    update_interval=5,
                    padding=4,
                    mouse_callbacks={
                        'Button1':
                        lambda qtile: qtile.cmd_spawn('pavucontrol'),
                        'Button3':
                        lambda qtile: qtile.cmd_spawn('pamixer --toggle-mute'),
                    },
                ),
                widget.Clock(
                    format='%H:%M',
                    mouse_callbacks={
                        'Button1': lambda qtile: qtile.cmd_spawn('gsimplecal')
                    },
                ),
                widget.Spacer(length=8),
            ],
            34,
            background=nord_colors[0]),
    ),
]
