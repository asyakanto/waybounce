import json
import subprocess
from time import sleep, time
import os

# Config
CONFIG_PATH = os.path.expanduser("~/.config/waybounce/config.json")

with open(CONFIG_PATH, "r") as f:
    config = json.load(f)

xSpeed = config.get("xSpeed", 6)
ySpeed = config.get("ySpeed", 4)
sleepTime = config.get("sleep", 0.01)
refreshInterval = config.get("refreshInterval", 2)

# State
monitors = []
lastUpdate = 0

# Helpers
def run(cmd):
    try:
        return subprocess.check_output(cmd, shell=True).decode()
    except:
        return ""

def get_monitors():
    data = json.loads(run("hyprctl monitors -j"))
    result = []

    for m in data:
        result.append((m["width"], m["height"], m["x"], m["y"]))

    return result

def get_cursor():
    x, y = run("hyprctl cursorpos").strip().split(", ")
    return int(float(x)), int(float(y))

def get_monitor(x, y):
    for w, h, mx, my in monitors:
        if mx <= x <= mx + w and my <= y <= my + h:
            return (w, h, mx, my)
    return None

def has_monitor(x, y):
    for w, h, mx, my in monitors:
        if mx <= x <= mx + w and my <= y <= my + h:
            return True
    return False

# Main loop
while True:
    now = time()

    if now - lastUpdate > refreshInterval:
        monitors = get_monitors()
        lastUpdate = now

    x, y = get_cursor()
    mon = get_monitor(x, y)

    if mon:
        w, h, mx, my = mon

        nx = x + xSpeed
        ny = y + ySpeed

        if nx < mx and not has_monitor(nx, y):
            xSpeed = abs(xSpeed)
        elif nx > mx + w and not has_monitor(nx, y):
            xSpeed = -abs(xSpeed)

        if ny < my and not has_monitor(x, ny):
            ySpeed = abs(ySpeed)
        elif ny > my + h and not has_monitor(x, ny):
            ySpeed = -abs(ySpeed)

    subprocess.Popen(f"ydotool mousemove -x {xSpeed} -y {ySpeed}", shell=True)
    sleep(sleepTime)