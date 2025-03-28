import subprocess
from libqtile import hook
from modules.global_items import HOME_DIR

@hook.subscribe.startup_once
def autostart():
    subprocess.run(f'{HOME_DIR}/.config/qtile/autostart.sh')