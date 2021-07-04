# ----------------------------------
# QTILE TILING WINDOW MANAGER CONFIG
# ----------------------------------

from libqtile import bar, hook, layout, widget, qtile
from libqtile.config import Drag, Click, Group, Key, Screen, Match
from libqtile.lazy import lazy
# pylint: disable=invalid-name,line-too-long,missing-function-docstring


# AUTOSTART
# ---------
@hook.subscribe.startup_once
def autostart():
    processes = [
        'dunst',
        'picom --daemon',
        'syncthing -no-browser',
        'light-locker',
        'unclutter --fork -timeout 15',
    ]
    for process in processes:
        qtile.cmd_spawn(process)


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
    Key([win, shift], 'o', lazy.group.unminimize_all()),
    Key([win], 'equal', lazy.layout.grow()),
    Key([win], 'minus', lazy.layout.shrink()),
    Key([win, shift], 'equal', lazy.layout.grow_main()),
    Key([win, shift], 'minus', lazy.layout.shrink_main()),
    # Program shortcuts
    Key([win], 'Return', lazy.spawn('alacritty')),
    Key([win], 'BackSpace', lazy.spawn('thunar')),
    Key([win], 'space', lazy.spawn('rofi -show drun')),
    Key([win], 'w', lazy.spawn('firefox')),
    Key([win], 's', lazy.spawn('signal-desktop')),
    Key([win], 'm', lazy.spawn('spotify')),
    Key([win], 'b', lazy.spawn('bitwarden')),
    # System shortcuts
    Key([], 'Print', lazy.spawn('screenshot')),
    Key([shift], 'Print', lazy.spawn('screenshot full')),
    Key([win], 'grave', lazy.spawn('dunstctl history-pop')),
    Key([win, shift], 'grave', lazy.spawn('dunstctl close-all')),
    Key([win], 'q', lazy.window.kill()),
    Key([win, shift], 'r', lazy.restart()),
    Key([win, shift], 'b', lazy.hide_show_bar('bottom')),
    Key([win, shift], 'q', lazy.spawn('rofi-powermenu')),
]

mouse = [
    Drag(
        [win],
        'Button1',
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
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
for g in groups:
    keys.extend(
        [
            Key(
                [win],
                g.name,
                lazy.group[g.name].toscreen(),
            ),
            Key(
                [win, shift],
                g.name,
                lazy.window.togroup(g.name, switch_group=True),
            )
        ])
keys.append(Key([win], 'Tab', lazy.screen.toggle_group()))

# LAYOUTS
# -------
nord_colors = [
    '#2e3440',    #0
    '#3b4252',    #1
    '#434c5e',    #2
    '#4c566a',    #3
    '#d8dee9',    #4
    '#e5e9f0',    #5
    '#eceff4',    #6
    '#8fbcbb',    #7
    '#88c0d0',    #8
    '#81a1c1',    #9
    '#5e81ac',    #10
    '#bf616a',    #11
    '#d08770',    #12
    '#ebcb8b',    #13
    '#a3be8c',    #14
    '#b48ead',    #15
]

theme_layout = {
    'border_width': 6,
    'margin': 5,
    'border_focus': nord_colors[9],
    'border_normal': nord_colors[3],
}

layouts = [
    layout.MonadTall(
        new_at_current=False,
        ratio=0.55,
        max_ratio=0.85,
        min_ratio=0.15,
        change_ratio=0.05,
        **theme_layout,
    ),
    layout.Max(**theme_layout),
]

floating_layout = layout.Floating(
    # Run `xprop` to add more float rules
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(title='pinentry'),    # GPG key password entry
        Match(wm_class='pavucontrol'),
        Match(wm_class='gsimplecal'),
        Match(wm_class='Places'),    # Firefox history/downloads
        Match(title="Customize Chart"), # Gnumeric
    ],
    **theme_layout,
)

auto_fullscreen = True
focus_on_window_activation = 'smart'

# SCREENS & WIDGETS
# -----------------
widget_defaults = {
    'font': 'NotoSans Nerd Font',
    'padding': 4,
    'foreground': nord_colors[6],
    'markup': True,
    'fontsize': 14,
}

screens = [
    Screen(
        wallpaper='~/.local/share/backgrounds/forest.jpg',
        wallpaper_mode='fill',
        bottom=bar.Bar(
            size=35,
            background=nord_colors[0],
            widgets=[
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
                widget.Spacer(length=6),
                widget.Clock(
                    format='%H:%M',
                    mouse_callbacks={
                        'Button1': lambda: qtile.cmd_spawn('gsimplecal')
                    },
                    fmt='<b>{}</b>',
                ),
                widget.Spacer(length=8),
            ],
        ),
    ),
]

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits. We choose LG3D to maximize irony: it is a 3D
# non-reparenting WM written in java that happens to be on java's whitelist.
wmname = 'LG3D'
