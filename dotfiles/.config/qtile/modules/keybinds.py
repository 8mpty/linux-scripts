
from libqtile.config import Click, Drag, Key
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from modules.global_items import *

terminal = guess_terminal()
# --------------------
# Available Terminals
# --------------------
# "roxterm"
# "sakura"
# "hyper"
# "alacritty"
# "terminator"
# "termite"
# "gnome-terminal"
# "konsole"
# "xfce4-terminal"
# "lxterminal"
# "mate-terminal"
# "kitty"
# "ghostty"
# "yakuake"
# "tilda"
# "guake"
# "eterm"
# "st"
# "urxvt"
# "wezterm"
# "xterm"
# "x-terminal-emulator"


mouse = [
    # Mouse Controls | Drag floating layouts.

    Drag([win], mse_left_btn, lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([win], mse_right_btn, lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([win], mse_mid_btn, lazy.window.bring_to_front()),
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
    Key([win], enter, lazy.spawn(terminal), desc="Launch terminal"),
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
    Key([win], "e", lazy.spawn("thunar")),
]


# Export to Qtile [config.py]
keys = [
    *window_focus,
    *window_movement,
    *window_grow,
    *launch_terminal,
    *layout_controls,
    *custom_controls,
]
