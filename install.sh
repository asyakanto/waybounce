#!/bin/bash

set -e

DIR="$HOME/.config/waybounce"
HYPR="$HOME/.config/hypr/hyprland.conf"

echo "=== Waybounce v1.0 Installer FIXED ==="

# 1. Dependencies
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed python ydotool git
elif command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y python3 ydotool git
fi

# 2. USER ydotoold service
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/ydotoold.service << EOF
[Unit]
Description=ydotool daemon

[Service]
ExecStart=/usr/bin/ydotoold
Restart=always
RestartSec=1

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now ydotoold.service

echo "ydotoold started (user service)"

# 3. Repo
if [ ! -d "$DIR/.git" ]; then
    rm -rf "$DIR"
    git clone https://github.com/asyakanto/waybounce.git "$DIR"
else
    git -C "$DIR" pull || true
fi

# 4. Config
mkdir -p "$DIR"

cat > "$DIR/config.json" << EOF
{
  "xSpeed": 6,
  "ySpeed": 4,
  "sleep": 0.01,
  "refreshInterval": 2
}
EOF

# 5. Waybounce service
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/waybounce.service << EOF
[Unit]
Description=Waybounce daemon
After=ydotoold.service

[Service]
Type=simple
ExecStart=/usr/bin/python3 %h/.config/waybounce/main.py
Restart=always
RestartSec=1

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable waybounce.service || true

# 6. Hyprland binds
touch "$HYPR"

add() {
    grep -qxF "$1" "$HYPR" || echo "$1" >> "$HYPR"
}

echo "" >> "$HYPR"
echo "# Waybounce binds" >> "$HYPR"

add "bind = SUPER_ALT, D, exec, systemctl --user restart waybounce.service"
add "bind = SUPER_SHIFT, D, exec, systemctl --user stop waybounce.service"

hyprctl reload

rm -rf ~/waybounce

# 7. Finish
echo "=== Installation complete ==="
echo "Start: Super Alt D"
echo "or: systemctl --user start waybounce.service"
echo "Stop: Super Shift D"
