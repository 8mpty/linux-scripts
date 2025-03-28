colors = {
    "white" : "FFFFFF",
    "pink" : "C90076",
    "black": "000000",
    "grey": "404040",
}

layout_config={
    "margin": [0, 10, 10, 10], # Top, Right, Bottom, Left
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