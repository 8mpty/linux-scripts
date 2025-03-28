from libqtile import bar
from libqtile.config import Screen

import modules.autostart                                        # Imports [Autostart] scripts and functions
import modules.global_items as gi                               # Imports [Global] values
from modules.keybinds import keys                               # Imports [All Keybinds]
from modules.workspaces import groups, layouts, widgets_list    # Imports all [Workspaces | Layouts]

def init_widgets_main():
    widgets_main = widgets_list()
    # del widgets_main[5:6]
    return widgets_main

def init_screens():
    return [
        # Screen(top=bar.Gap(1)), # No bar
        Screen(top=bar.Bar(init_widgets_main(), size=38, margin=[5, 10, 5, 10]), wallpaper=gi.wallpaper_path, wallpaper_mode='fill'),
    ]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_main()
    

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
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

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"