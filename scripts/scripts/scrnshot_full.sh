#!/bin/bash

# Set screenshot save directory
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Create timestamped filename
FILE="$DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Detect session and capture full screen
if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
  # --- WAYLAND SESSION ---
  if ! command -v grim &>/dev/null; then
    echo "Error: 'grim' is not installed." >&2
    exit 1
  fi
  grim "$FILE"
else
  # --- X11 SESSION (i3) ---
  if ! command -v maim &>/dev/null; then
    echo "Error: 'maim' is not installed." >&2
    exit 1
  fi
  maim "$FILE"
fi

# View the screenshot using imv
if [ -f "$FILE" ] && command -v imv &>/dev/null; then
  imv "$FILE"
fi
