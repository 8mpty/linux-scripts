from pathlib import Path
from datetime import datetime
import subprocess, re

# ========== Battery Widget Function ==========
def battery_status():
    battery_path = Path("/sys/class/power_supply/BAT1")

    if not battery_path.exists():
        return "󱉞 AC"

    try:
        status = (battery_path / "status").read_text().strip().lower()
        capacity = int((battery_path / "capacity").read_text().strip())

        # Charging icons
        charging_icons = {
            10: "󰢜",
            20: "󰂆",
            30: "󰂇",
            40: "󰂈",
            50: "󰢝",
            60: "󰂉",
            70: "󰢞",
            80: "󰂊",
            90: "󰂋",
            100: "󰁹",
        }

        # Discharging icons
        discharging_icons = {
            10: "󰁺",
            20: "󰁻",
            30: "󰁼",
            40: "󰁽",
            50: "󰁾",
            60: "󰁿",
            70: "󰂀",
            80: "󰂁",
            90: "󰂂",
            100: "󰁹",
        }

        def get_icon(capacity, icons):
            for level in sorted(icons):
                if capacity <= level:
                    return icons[level]
            return icons[100]

        icon = get_icon(capacity, charging_icons if status == "charging" else discharging_icons)
        return f"{icon} {capacity}%"

    except Exception:
        return "Battery Error"

# ========== Clock Toggle Widget Function ==========
clock_toggle = [False]  # Mutable for toggle behavior

def clock_func():
    if clock_toggle[0]:
        return datetime.now().strftime("%a, %d/%m/%Y | %H:%M:%S %p")
    else:
        return datetime.now().strftime("%H:%M:%S %p")

# Toggle function for the callback
def toggle_clock(widget):
    clock_toggle[0] = not clock_toggle[0]
    widget.tick()


# ========== Pulse Audio Widget Function ==========
def audio_status():
    try:
        output = subprocess.check_output(["pactl", "get-sink-mute", "@DEFAULT_SINK@"], text=True).strip()
        muted = "yes" in output

        if muted:
            return "󰝟 Muted"

        # Get volume level
        volume_output = subprocess.check_output(["pactl", "get-sink-volume", "@DEFAULT_SINK@"], text=True)
        # Extract the percentage from the output (e.g., "Volume: front-left: 65536 / 100% / 0.00 dB")
        for line in volume_output.splitlines():
            if "%" in line:
                percent = line.split("/")[1].strip()
                return f"󰕾 {percent}"

        return "󰖁 ??%"
    except Exception:
        return "Audio Error"


# ========== IP Widget Function ==========  
def ip_status():
    try:
        output = subprocess.check_output(["ip", "-4", "-o", "addr", "show", "up"], text=True)
        for line in output.splitlines():
            parts = line.split()
            iface = parts[1]
            ip_addr = parts[3].split("/")[0]
            if iface != "lo":
                return f"{iface}: {ip_addr}"
        return "No IP"
    except Exception:
        return "IP Error"