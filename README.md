# Waybounce

Waybounce is a lightweight Python daemon for **Hyprland** that simulates smooth cursor movement with “bounce” behavior across multiple monitors using `ydotool`.

---

## About

- Smooth cursor movement simulation
- Multi-monitor aware (Hyprland)
- Edge bounce logic between displays
- Runs as a **systemd user service**
- Minimal, fast, and lightweight design

---

## Requirements

- Linux (Wayland only)
- Hyprland
- Python 3
- `ydotool` + `ydotoold`

### Arch Linux

```bash
sudo pacman -S ydotool python git
```

### Debian / Ubuntu

```bash
sudo apt install ydotool python3 git
```

---

## Installation

Clone repo and run installer:

```bash
git clone https://github.com/asyakanto/waybounce.git
cd waybounce
bash install.sh
cd ..
rm -rf waybounce
```

The installer will:

- install dependencies
- start `ydotoold` (user service)
- clone/update project
- create configuration file
- register systemd user service
- add Hyprland keybinds

---

## Services

Waybounce runs via systemd user services:

```bash
systemctl --user start waybounce.service
systemctl --user stop waybounce.service
systemctl --user restart waybounce.service
```

---

## Controls (Hyprland)

- `SUPER + ALT + D` → restart Waybounce
- `SUPER + SHIFT + D` → stop Waybounce

---

## Configuration

Edit:

```bash
~/.config/waybounce/config.json
```

```json
{
  "xSpeed": 6,
  "ySpeed": 4,
  "sleep": 0.01,
  "refreshInterval": 2
}
```

### Parameters

- `xSpeed` — horizontal movement speed
- `ySpeed` — vertical movement speed
- `sleep` — update delay (lower = smoother, heavier CPU)
- `refreshInterval` — monitor refresh interval (seconds)

---

## Uninstall

```bash
systemctl --user stop waybounce.service
systemctl --user disable waybounce.service
rm -rf ~/.config/waybounce
```

---

## Author

Asya <333
