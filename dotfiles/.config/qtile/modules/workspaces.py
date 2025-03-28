from libqtile import layout, widget
from libqtile.config import Group, Key, Match
from libqtile.lazy import lazy

from modules.keybinds import keys
from modules.global_items import win, shift, rofi_power_menu, rofi_app_menu, wallpaper_path
from modules.styles import *

groups = []
grp_names = ["1", "2", "3", "4", "5"]
grp_labels = ["1", "2", "3", "4", "5"]
grp_matches = [[Match(wm_class='code')], [Match(wm_class='zen')], "", "", ""]
grp_layouts = ["", "", "", "", ""]

for i in range(len(grp_names)):
    groups.append(
        Group(name=grp_names[i], label=grp_labels[i], matches=grp_matches[i], layout=grp_layouts[i].lower())
    )

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key([win], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
            
            # mod + shift + group number = move focused window to group
            Key([win, shift], i.name, lazy.window.togroup(i.name), desc=f"Switch focused window to group {i.name}"),
        ]
    )

layouts = [
    layout.MonadTall(**layout_config),
    layout.Max(**layout_config),
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
    # fontsize=16,
)

extension_widgets = widget_defaults.copy()

def widgets_list():
    bar_widgets = [
        widget.TextBox(" Menu", mouse_callbacks ={"Button1": lazy.spawn(rofi_app_menu)}, fontsize=16),
        widget.Sep(**sep_style),
        widget.GroupBox(**groupbox_style),
        widget.Sep(**sep_style),
        widget.WindowName(**window_name_style),
        widget.WidgetBox(
            **widget_box_style,
            text_closed="󰍞",
            widgets=[
                widget.CurrentLayout(),
                widget.Sep(**sep_style),
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
        widget.TextBox("󰈆 ", mouse_callbacks ={"Button1": lazy.spawn(rofi_power_menu)}, fontsize=22),
    ]
    return bar_widgets

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