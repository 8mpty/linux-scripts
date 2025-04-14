############################################################################################################
# ██╗░░░░░░█████╗░██╗░░░██╗░█████╗░██╗░░░██╗████████╗  ░██████╗████████╗██╗░░░██╗██╗░░░░░███████╗░██████╗ #
# ██║░░░░░██╔══██╗╚██╗░██╔╝██╔══██╗██║░░░██║╚══██╔══╝  ██╔════╝╚══██╔══╝╚██╗░██╔╝██║░░░░░██╔════╝██╔════╝ #
# ██║░░░░░███████║░╚████╔╝░██║░░██║██║░░░██║░░░██║░░░  ╚█████╗░░░░██║░░░░╚████╔╝░██║░░░░░█████╗░░╚█████╗░ #
# ██║░░░░░██╔══██║░░╚██╔╝░░██║░░██║██║░░░██║░░░██║░░░  ░╚═══██╗░░░██║░░░░░╚██╔╝░░██║░░░░░██╔══╝░░░╚═══██╗ #
# ███████╗██║░░██║░░░██║░░░╚█████╔╝╚██████╔╝░░░██║░░░  ██████╔╝░░░██║░░░░░░██║░░░███████╗███████╗██████╔╝ #
# ╚══════╝╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░░╚═════╝░░░░╚═╝░░░  ╚═════╝░░░░╚═╝░░░░░░╚═╝░░░╚══════╝╚══════╝╚═════╝░ #
############################################################################################################
import os

HOME_DIR = os.path.expanduser("~")
QTILE_DIR = f"{HOME_DIR}/.config/qtile/scripts"

def get_bar_size():
    try:
        with open(f"{QTILE_DIR}/barsize", "r") as size:
            return int(size.read())
    except:
        return 25  # Default height

bar_size = get_bar_size()

colors = {
    "white" : "FFFFFF",
    "pink" : "C90076",
    "black": "000000",
    "grey": "404040",
    "green": "00FF00",
    "yt-grey": "0F0F0F"
}

layout_config={
    # "margin": [0, 10, 10, 10], # Top, Right, Bottom, Left
    "margin": 10,
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

window_name_style = dict(
    fontsize=15,
    foreground=colors["white"],
    background=colors["black"],
)

clock_style = dict(
    foreground=colors["white"], 
    fontsize=int(bar_size * 0.4)  # Adjust scaling as needed
)

groupbox_style = dict(
    disable_drag=True,
    highlight_method='block',
    inactive=colors["grey"],
    fontsize=int(bar_size * 0.45),
    urgent_alert_method="border",
    this_current_screen_border=colors["pink"],
    # hide_unused=True
)

widget_box_style = dict(
    close_button_location="right",
    fontsize=int(bar_size * 1.05),
    padding=int(bar_size * 0.16),
    text_open="󰍟",
    text_closed="󰍞",
)

window_mode_style = dict(
    fontsize=int(bar_size * 0.47)
)

tasklist_style = dict(
    fontsize=int(bar_size * 0.38),
    padding=int(bar_size * 0.18),
    highlight_method="block", 
    border=colors["pink"], 
    title_width_method="uniform",
    txt_maximized="  ",
    txt_minimized="  ",
    txt_floating="🗗"
)

power_btn_style = dict(
    text=" ",
    fontsize=int(bar_size * 0.54)
)

systray_style = dict(
    icon_size=int(bar_size * 0.6)
)

memory_style = dict(
    fontsize=int(bar_size * 0.47)
)

appmenu_style = dict(
    text="",
    fontsize=int(bar_size * 0.7)
)

def gen_pool_style(f, update_int, mse_callbacks=None):
    return dict(
        fontsize=int(bar_size * 0.47),
        func=f,
        update_interval=int(update_int),
        fmt="{}",
        mouse_callbacks=mse_callbacks or {}
    )