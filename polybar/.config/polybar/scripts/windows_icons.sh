#!/usr/bin/env python3
"""
Window icons module for Polybar on i3wm.
Reads visible windows on the currently focused workspace and displays corresponding icons.
"""
import sys
import i3ipc

# App names / classes mapping to icons (preserved from Hyprland configuration)
ICONS = {
    "brave-browser": "󰈹",
    "firefox-developer-edition": "",
    "firefox": "",
    "google-chrome": "",
    "chromium": "",
    "alacritty": "",
    "foot": "",
    "kitty": "",
    "code": "󰨞",
    "dev.zed.zed": "",
    "zed": "",
    "gitkraken": "",
    "org.kde.dolphin": "",
    "dolphin": "",
    "org.telegram.desktop": "",
    "telegram": "",
    "thunar": "",
    "pcmanfm": "",
    "vlc": "",
    "mpv": "",
    "imv": "",
    "discord": "",
    "steam": "",
    "spotify": "",
    "jetbrains-studio": "",
    "antigravity": "󰠄",
    "antigravity ide": "󰠄",
    "libreoffice-writer": "",
    "minecraft": "󰍳",
    "virt-manager": "",
    "com.obsproject.studio": "󱜏",
    "obs": "󱜏",
    "blender": "󰂫",
}

def get_icon(app):
    if not app:
        return ""
    app_low = app.lower()
    if app_low in ICONS:
        return ICONS[app_low]
    for k, v in ICONS.items():
        if k in app_low or app_low in k:
            return v
    return ""

def render(i3, *_):
    tree = i3.get_tree()
    output = []
    seen = set()

    for leaf in tree.leaves():
        if not leaf.window:
            continue
        ws = leaf.workspace()
        if ws and ws.name.startswith("__"):
            continue
        app = leaf.window_instance or leaf.window_class or ""
        app_key = app.lower()
        if app_key in seen:
            continue
        seen.add(app_key)
        icon = get_icon(app)
        item = f"%{{A1:i3-msg [id={leaf.window}] focus:}}{icon}%{{A}}"
        output.append(item)

    if output:
        print("  ".join(output) + " ", flush=True)
    else:
        print("", flush=True)

try:
    i3 = i3ipc.Connection()
    render(i3)
    if "--once" in sys.argv:
        sys.exit(0)
    for ev in ("workspace", "window"):
        i3.on(ev, render)
    i3.main()
except Exception:
    print("", flush=True)
