import subprocess, os, re
from libqtile import bar, hook, layout, widget
from libqtile.config import Screen, Click, Drag, Key, Group, Match
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


########################################################################
# ██╗░░░██╗░█████╗░██████╗░██╗░█████╗░██████╗░██╗░░░░░███████╗░██████╗ #
# ██║░░░██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║░░░░░██╔════╝██╔════╝ #
# ╚██╗░██╔╝███████║██████╔╝██║███████║██████╦╝██║░░░░░█████╗░░╚█████╗░ #
# ░╚████╔╝░██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║░░░░░██╔══╝░░░╚═══██╗ #
# ░░╚██╔╝░░██║░░██║██║░░██║██║██║░░██║██████╦╝███████╗███████╗██████╔╝ #
# ░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝╚══════╝╚═════╝░ #
########################################################################

HOME_DIR = os.path.expanduser("~")

# Special Keys
alt = "mod1"
win = "mod4"
shift = "Shift"
control = "Control"
tab = "Tab"
enter = "Return"
backspace = "Backspace"
space = "Space"
escape = "Escape"
delete = "Delete"
home = "Home"
num_lock = "Num_Lock"
caps_lock = "Caps_Lock"

# Audio Keys
audio_inc = "XF86AudioRaiseVolume"
audio_dec = "XF86AudioLowerVolume"
audio_mute = "XF86AudioMute"
audio_play = "XF86AudioPlay"
audio_stop = "XF86AudioStop"
audio_next = "XF86AudioNext"
audio_prev = "XF86AudioPrev"

# Screen Brightness
screen_bright_inc = "XF86MonBrightnessUp"
screen_bright_dec = "XF86MonBrightnessDown"

# Keyboard Brightness
keyboard_bright_toggle = "XF86KbdLightOnOff"
keyboard_bright_inc = "XF86KbdBrightnessUp"
keyboard_bright_dec = "XF86KbdBrightnessDown"

# Arrow Keys
left_arrow = "Left"
right_arrow = "Right"
up_arrow = "Up"
down_arrow = "Down"

# Mouse Buttons
mouse_left_btn = "Button1"
mouse_scroll_btn = "Button2"
mouse_right_btn = "Button3"

# Applications
terminal = guess_terminal()
filemanager = "thunar"

# Rofi Scripts
rofi_app_menu = "rofi -show drun"
rofi_alt_tab="rofi -show window"
rofi_power_menu = f"{HOME_DIR}/.config/rofi/rofi-power-menu.sh"

# Static Wallpaper Path
wallpaper_path = f"{HOME_DIR}/Pictures/wallpaper3.png"


############################################################################################################
# ██╗░░░░░░█████╗░██╗░░░██╗░█████╗░██╗░░░██╗████████╗  ░██████╗████████╗██╗░░░██╗██╗░░░░░███████╗░██████╗ #
# ██║░░░░░██╔══██╗╚██╗░██╔╝██╔══██╗██║░░░██║╚══██╔══╝  ██╔════╝╚══██╔══╝╚██╗░██╔╝██║░░░░░██╔════╝██╔════╝ #
# ██║░░░░░███████║░╚████╔╝░██║░░██║██║░░░██║░░░██║░░░  ╚█████╗░░░░██║░░░░╚████╔╝░██║░░░░░█████╗░░╚█████╗░ #
# ██║░░░░░██╔══██║░░╚██╔╝░░██║░░██║██║░░░██║░░░██║░░░  ░╚═══██╗░░░██║░░░░░╚██╔╝░░██║░░░░░██╔══╝░░░╚═══██╗ #
# ███████╗██║░░██║░░░██║░░░╚█████╔╝╚██████╔╝░░░██║░░░  ██████╔╝░░░██║░░░░░░██║░░░███████╗███████╗██████╔╝ #
# ╚══════╝╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░░╚═════╝░░░░╚═╝░░░  ╚═════╝░░░░╚═╝░░░░░░╚═╝░░░╚══════╝╚══════╝╚═════╝░ #
############################################################################################################

colors = {
    "white" : "FFFFFF",
    "pink" : "C90076",
    "black": "000000",
    "grey": "404040",
    "green": "00FF00"
}

layout_config={
    # "margin": [0, 10, 10, 10], # Top, Right, Bottom, Left
    "border_width": 2,
    "border_focus": colors["pink"],
    "border_normal": colors["grey"],
    "grow_amount": 2 # For Column Layout
}

sep_style = dict(
    foreground=colors["white"], 
    linewidth=2, 
    size_percent=60, 
    padding=10
)

clock_style = dict(
    foreground=colors["white"], 
    fontsize=15
)

groupbox_style = dict(
    disable_drag=True,
    highlight_method='block',
    inactive=colors["grey"],
    fontsize=17,
    padding=3,
    urgent_alert_method="border",
    this_current_screen_border=colors["pink"],
    hide_unused=True
)

window_name_style = dict(
    fontsize=15,
    foreground=colors["white"],
    background=colors["black"],
)

widget_box_style = dict(
    close_button_location="right",
    fontsize=40,
    padding=6,
    text_open="󰍟",
)


################################################################################
# ░█████╗░██╗░░░██╗████████╗░█████╗░░██████╗████████╗░█████╗░██████╗░████████╗ #
# ██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝ #
# ███████║██║░░░██║░░░██║░░░██║░░██║╚█████╗░░░░██║░░░███████║██████╔╝░░░██║░░░ #
# ██╔══██║██║░░░██║░░░██║░░░██║░░██║░╚═══██╗░░░██║░░░██╔══██║██╔══██╗░░░██║░░░ #
# ██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██████╔╝░░░██║░░░██║░░██║██║░░██║░░░██║░░░ #
# ╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░ #
################################################################################

@hook.subscribe.startup_once
def autostart():
    subprocess.run(f'{HOME_DIR}/.config/qtile/autostart.sh')


#################################################################
# ██╗░░██╗███████╗██╗░░░██╗██████╗░██╗███╗░░██╗██████╗░░██████╗ #
# ██║░██╔╝██╔════╝╚██╗░██╔╝██╔══██╗██║████╗░██║██╔══██╗██╔════╝ #
# █████═╝░█████╗░░░╚████╔╝░██████╦╝██║██╔██╗██║██║░░██║╚█████╗░ #
# ██╔═██╗░██╔══╝░░░░╚██╔╝░░██╔══██╗██║██║╚████║██║░░██║░╚═══██╗ #
# ██║░╚██╗███████╗░░░██║░░░██████╦╝██║██║░╚███║██████╔╝██████╔╝ #
# ╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═════╝░╚═╝╚═╝░░╚══╝╚═════╝░╚═════╝░ #
#################################################################

mouse = [
    # Mouse Controls | Drag floating layouts.
    Drag([win], mouse_left_btn, lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([win], mouse_right_btn, lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([win], mouse_scroll_btn, lazy.window.bring_to_front()),
]

window_focus = [
    # -----------------------
    #  Window Focus Controls
    # -----------------------

    # Win + Alt + H = Focus to [Left] 
    # Win + Alt + L = Focus to [Right]
    # Win + Alt + J = Focus to [Down]
    # Win + Alt + K = Focus to [Up]
    # Win + Alt + Space = Move focus to next available window and continue
    Key([win, alt], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([win, alt], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([win, alt], "j", lazy.layout.down(), desc="Move focus down"),
    Key([win, alt], "k", lazy.layout.up(), desc="Move focus up"),
    Key([win, alt], "space", lazy.layout.next(), desc="Move window focus to other window"),
]

window_movement = [
    # --------------------------
    #  Window Movement Controls
    # --------------------------

    # Win + Shift + H = Move window to [Left] 
    # Win + Shift + L = Move window to [Right]
    # Win + Shift + J = Move window to [Down]
    # Win + Shift + K = Move window to [Up]

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([win, shift], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([win, shift], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([win, shift], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([win, shift], "k", lazy.layout.shuffle_up(), desc="Move window up"),
]

window_grow = [
    # -----------------------
    #  Window Grow Controls 
    # -----------------------

    # Win + Control + H = Grow window to [Left] 
    # Win + Control + L = Grow window to [Right]
    # Win + Control + J = Grow window to [Down]
    # Win + Control + K = Grow window to [Up]
    # Win + Control + N = Reset all window sizes

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([win, control], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([win, control], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([win, control], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([win, control], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([win, control], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
]

launch_terminal = [
    # -----------------------
    #    Launch Terminal 
    # -----------------------

    # Win + Enter = Launches terminal
    Key([win], enter, lazy.spawn(terminal)),
]

layout_controls = [
    # -----------------------
    #    Layout Controls 
    # -----------------------

    # Win + Tab = Toggle Available Layouts 
    # Win + Q = [Quit / Kill] current focused window
    # Win + F = Toggle [Fullscreen] status of current focused window
    # Win + T = Toggle [Floating] status of current focused window
    # Win + Control + R = [Reload] whole Qtile config
    # Win + Control + Q = [Shutdown] Qtile
    Key([win], tab, lazy.next_layout(), desc="Toggle between layouts"),
    Key([win], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([win], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
    Key([win], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([win, control], "r", lazy.reload_config(), desc="Reload the config"),
    Key([win, control], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]

custom_controls = [
    # -----------------------
    #    Custom Controls 
    # -----------------------

    # Win + Space = Open [Rofi App] menu
    # Alt + Tab = Open [Rofi "Alt Tab"] menu
    # Win + L = Open [Rofi "Power Menu"] menu
    # Win + E = Open ["thunar"]
    Key([win], space, lazy.spawn(rofi_app_menu)),
    Key([alt], tab, lazy.spawn(rofi_alt_tab)),
    Key([win], "l", lazy.spawn(rofi_power_menu)),  
    Key([win], "e", lazy.spawn(filemanager)),
]

# Export Keys to Qtile
keys = [
    *window_focus,
    *window_movement,
    *window_grow,
    *launch_terminal,
    *layout_controls,
    *custom_controls,
]


##########################################################################################
# ░██╗░░░░░░░██╗░█████╗░██████╗░██╗░░██╗░██████╗██████╗░░█████╗░░█████╗░███████╗░██████╗ #
# ██║░░██╗░░██║██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝  #
# ░╚██╗████╗██╔╝██║░░██║██████╔╝█████═╝░╚█████╗░██████╔╝███████║██║░░╚═╝█████╗░░╚█████╗░ #
# ░░████╔═████║░██║░░██║██╔══██╗██╔═██╗░░╚═══██╗██╔═══╝░██╔══██║██║░░██╗██╔══╝░░░╚═══██╗ #
# ░░╚██╔╝░╚██╔╝░╚█████╔╝██║░░██║██║░╚██╗██████╔╝██║░░░░░██║░░██║╚█████╔╝███████╗██████╔╝ #
# ░░░╚═╝░░░╚═╝░░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░░░░╚═╝░░╚═╝░╚════╝░╚══════╝╚═════╝░ #
##########################################################################################

groups = []
grp_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
grp_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
grp_matches = [[Match(wm_class=re.compile(r"code"))], Match(wm_class=re.compile(r"zen|firefox-esr|firefox")), "", "", "", "", "", "", ""]
grp_layouts = ["", "", "", "", "", "", "", "", ""]

for i in range(len(grp_names)):
    groups.append(
        Group(name=grp_names[i], label=grp_labels[i], matches=grp_matches[i], layout=grp_layouts[i].lower())
    )

for i in groups:
    keys.extend(
        [
            # win + group number = switch to group
            Key([win], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
            
            # win + shift + group number = move focused window to group
            Key([win, shift], i.name, lazy.window.togroup(i.name), desc=f"Switch focused window to group {i.name}"),
        ]
    )

layouts = [
    layout.Max(**layout_config),
    layout.MonadTall(**layout_config),
    layout.Columns(**layout_config),
    
    # Try more layouts by unleashing below layouts.
    # layout.Tile(**layout_config),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="FiraCodeNerdFont",
    fontsize=20,
)

extension_widgets = widget_defaults.copy()

def is_laptop():
    return os.path.exists('/sys/class/power_supply/BAT0')

# Create the battery widget
if is_laptop():
    battery_widget = widget.Battery(
        format="{char} {percent:2.0%} {time}",
        charge_char="⚡",
        discharge_char="🔋",
        full_char="☻",
        update_interval=10,
    )
else:
    battery_widget = widget.TextBox(
        text="AC",
        fontsize=15,
        foreground=colors['green'],  # Green color
    )

def init_widgets_list():
    widgets_list = [
        widget.TextBox("", mouse_callbacks={mouse_left_btn: lazy.spawn(rofi_app_menu)}, fontsize=28),
        widget.Sep(**sep_style),
        widget.GroupBox(**groupbox_style),
        widget.Sep(**sep_style),
        widget.TaskList(fontsize=15, padding=6, highlight_method="block", border=colors["pink"], title_width_method="uniform"),
        widget.WindowName(**window_name_style),
        widget.WidgetBox(
            **widget_box_style,
            text_closed="󰍞",
            widgets=[
                widget.CurrentLayout(),
                widget.Sep(**sep_style),
                battery_widget,
                widget.Systray(),
            ]
        ),
        widget.WidgetBox(
            **widget_box_style,
            start_opened=True,
            text_closed="󰍞",
            widgets=[
                widget.Clock(format="%a, %d/%m/%Y | %H:%M:%S %p", **clock_style),
            ]
        ),
        widget.TextBox("󰈆 ", mouse_callbacks={mouse_left_btn: lazy.spawn(rofi_power_menu)}, fontsize=22),
    ]
    return widgets_list

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(title="branchdialog"),             # gitk
        Match(title="pinentry"),                 # GPG key password entry
        Match(wm_class="confirmreset"),          # gitk
        Match(wm_class="makebranch"),            # gitk
        Match(wm_class="maketag"),               # gitk
        Match(wm_class="ssh-askpass"),           # ssh-askpass
        Match(wm_class="nm-connection-editor"),  # Network Control Panel
        Match(wm_class="blueman-manager"),       # Bluetooth Control Panel
        Match(wm_class="pavucontrol"),           # Pulse Audio Control Panel
        Match(wm_class="arandr"),                # ARandr | Resolution | Display Panel
    ]
)


##########################################################################################
# ██╗███╗░░██╗██╗████████╗  ░██╗░░░░░░░██╗██╗██████╗░░██████╗░███████╗████████╗░██████╗ #
# ██║████╗░██║██║╚══██╔══╝  ░██║░░██╗░░██║██║██╔══██╗██╔════╝░██╔════╝╚══██╔══╝██╔════╝ #
# ██║██╔██╗██║██║░░░██║░░░  ░╚██╗████╗██╔╝██║██║░░██║██║░░██╗░█████╗░░░░░██║░░░╚█████╗░ #
# ██║██║╚████║██║░░░██║░░░  ░░████╔═████║░██║██║░░██║██║░░╚██╗██╔══╝░░░░░██║░░░░╚═══██╗ #
# ██║██║░╚███║██║░░░██║░░░  ░░╚██╔╝░╚██╔╝░██║██████╔╝╚██████╔╝███████╗░░░██║░░░██████╔╝ #
# ╚═╝╚═╝░░╚══╝╚═╝░░░╚═╝░░░  ░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░░╚═════╝░╚══════╝░░░╚═╝░░░╚═════╝░ #
##########################################################################################

def init_widgets_main():
    widgets_main = init_widgets_list()
    del widgets_main[4:5]
    return widgets_main

def init_widgets_main_bottom():
    widgets_screen2 = init_widgets_list()
    widgets_screen2 = [
        widgets_list[2]
    ]
    return widgets_screen2

def init_screens():
    return [
        # Screen(top=bar.Gap(1)), # No bar
        Screen(top=bar.Bar(widgets=init_widgets_main(), size=38), wallpaper=wallpaper_path, wallpaper_mode='fill'),
        # Screen(top=bar.Bar(widgets=init_widgets_main(), size=38), bottom=bar.Bar(widgets=init_widgets_main_bottom(), size=38), wallpaper=wallpaper_path, wallpaper_mode='fill'),
        # Screen(bottom=bar.Bar(widgets=init_widgets_main_bottom(), size=38)),
    ]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_main_top = init_widgets_main()
    widgets_main_bot = init_widgets_main_bottom()
    

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = False
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
wmname = "LG3D"