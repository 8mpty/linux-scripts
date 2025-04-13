import subprocess, os, re, shutil
from libqtile import bar, hook, layout, widget
from libqtile.config import Screen, Click, Drag, Key, Group, Match, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import custom_widgets
import styles

# qtile cmd-obj -o cmd -f reload_config
# qtile cmd-obj -o cmd -f restart

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
mouse_scroll_up = "Button4"
mouse_scroll_down = "Button5"

# Applications
terminal = shutil.which("kitty") or guess_terminal()
filemanager = "thunar"
screenshot = "xfce4-screenshooter -r"
pavucontrol = "pavucontrol"
power_manager = "xfce4-power-manager-settings"
network_manager = "nm-connection-editor"

# Audio
audio_mute_toggle = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
audio_inc_1 = "pactl set-sink-volume @DEFAULT_SINK@ +1%"
audio_dec_1 = "pactl set-sink-volume @DEFAULT_SINK@ -1%"

# Rofi Scripts
rofi_app_menu = "rofi -show drun"
rofi_alt_tab="rofi -show window"
rofi_power_menu = f"{HOME_DIR}/.config/rofi/rofi-power-menu.sh"

# Static Wallpaper Path
wallpaper_path = f"{HOME_DIR}/.config/qtile/images/wallpaper1.jpg"


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

    # Win + Enter = Open [Terminal]
    # Win + Space = Open [Rofi App] menu
    # Alt + Tab = Open [Rofi "Alt Tab"] menu
    # Win + L = Open [Rofi "Power Menu"] menu
    # Win + E = Open ["thunar"]
    # Win + Shift + S = Open [xfce4-screenshotter] + [Only Region]
    # Keyboard Audio Increase Key = Increase Volume by +5
    # Keyboard Audio Decrease Key = Decrease Volume by +5
    # Keyboard Audio Mute Key = Toggle Audio Mute
    # Win + Control + h = Open [Kitty + Htop]
    # Win + Control + Enter = Open [ScratchPad Kitty]
    Key([win], enter, lazy.spawn(terminal)),
    Key([win], space, lazy.spawn(rofi_app_menu)),
    Key([alt], tab, lazy.spawn(rofi_alt_tab)),
    Key([win], "l", lazy.spawn(rofi_power_menu)),  
    Key([win], "e", lazy.spawn(filemanager)),
    Key([win, shift], "s", lazy.spawn(screenshot)),

    Key([], audio_inc, lazy.spawn(audio_inc_1)),
    Key([], audio_dec, lazy.spawn(audio_dec_1)),
    Key([], audio_mute, lazy.spawn(audio_mute_toggle)),

    # Key([win, control], "equal", ), # Increase Bar size +2 + reload_config
    # Key([win, control], "minus", ), # Decrease Bar size -2 + reload_config

    Key([win, control], "h", lazy.group['sp'].dropdown_toggle('htop')),
    Key([win, control], enter, lazy.group['sp'].dropdown_toggle('kitty'))
]

# Export Keys to Qtile
keys = [
    *window_focus,
    *window_movement,
    *window_grow,
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
grp_names = ["1", "2", "3", "4", "5"]
grp_labels = ["1", "2", "3", "4", "5"]
grp_matches = [[Match(wm_class=re.compile(r"code"))], Match(wm_class=re.compile(r"zen|firefox-esr|firefox")), "", "", ""]
grp_layouts = ["", "", "", "", ""]

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

# (1 - width or height) / 2
groups.append(ScratchPad("sp", [
    DropDown("htop", "kitty -e htop", width=0.6, height=0.6, x=0.2, y=0.2, on_focus_lost_hide=False),
    DropDown("kitty", "kitty", width=0.7, height=0.7, x=0.15, y=0.15, on_focus_lost_hide=False),
]))

layouts = [
    layout.Max(**styles.layout_config),
    layout.MonadTall(**styles.layout_config),
    layout.Columns(**styles.layout_config),
    
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
)

extension_widgets = widget_defaults.copy()
    
battery_widget = widget.GenPollText(
    **styles.gen_pool_style(custom_widgets.battery_status, 15, {
        mouse_left_btn: lazy.spawn(power_manager)
    })
)

clock_widget = widget.GenPollText(
    **styles.gen_pool_style(custom_widgets.clock_func, 0, {
        mouse_left_btn: lambda: custom_widgets.toggle_clock(clock_widget)
    })
)

audio_widget = widget.GenPollText(
    **styles.gen_pool_style(custom_widgets.audio_status, 0, {
        mouse_right_btn : lazy.spawn(pavucontrol),
        mouse_left_btn: lazy.spawn(audio_mute_toggle),
        mouse_scroll_up: lazy.spawn(audio_inc_1),
        mouse_scroll_down: lazy.spawn(audio_dec_1),
    })
)

ip_widget = widget.GenPollText(
    **styles.gen_pool_style(custom_widgets.ip_status, 10, {
        mouse_left_btn: lazy.spawn(network_manager)
    })
)

def init_widgets_list():
    widgets_list = [
        #widget.TextBox(**styles.appmenu_style, mouse_callbacks={mouse_left_btn: lazy.spawn(rofi_app_menu)}),
        #widget.Sep(**styles.sep_style),
        widget.GroupBox(**styles.groupbox_style),
        widget.Sep(**styles.sep_style),
        widget.CurrentLayout(**styles.window_mode_style),
        widget.Sep(**styles.sep_style),
        # widget.WindowName(**styles.window_name_style),
        widget.TaskList(**styles.tasklist_style),
        widget.Sep(**styles.sep_style),
        widget.WidgetBox(**styles.widget_box_style, widgets=[
            ip_widget,
            widget.Sep(**styles.sep_style),
            battery_widget,
            widget.Sep(**styles.sep_style),
            audio_widget,
            widget.Sep(**styles.sep_style),
            widget.Memory(**styles.memory_style, mouse_callbacks={mouse_left_btn: lazy.group['sp'].dropdown_toggle('htop')}),
            widget.Sep(**styles.sep_style),
            widget.Systray(**styles.systray_style)
            ]
        ),
        clock_widget,
        widget.TextBox(**styles.power_btn_style, mouse_callbacks={mouse_left_btn: lazy.spawn(rofi_power_menu)}),
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
    # del widgets_main[4:5] #BRUHHHHHH
    return widgets_main

def init_widgets_main_bottom():
    widgets_screen2 = init_widgets_list()
    widgets_screen2 = [
        widgets_list[3]
    ]
    return widgets_screen2

def init_screens():
    return [
        # Screen(top=bar.Gap(1)), # No bar
        Screen(top=bar.Bar(widgets=init_widgets_main(), background=styles.colors["yt-grey"], size=styles.bar_size), wallpaper=wallpaper_path, wallpaper_mode='fill'),
        # Screen(top=bar.Bar(widgets=init_widgets_main(), size=38), left=bar.Bar(widgets=init_widgets_main_bottom(), size=38), wallpaper=wallpaper_path, wallpaper_mode='fill'),
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