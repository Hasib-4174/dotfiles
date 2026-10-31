#!/bin/bash

# Configuration
SAVE_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
FILE="$SAVE_DIR/screenshot_$TIMESTAMP.png"

mkdir -p "$SAVE_DIR"

# Check if running under Wayland (Hyprland) or X11 (i3)
if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
  # --- WAYLAND SESSION (Hyprland) ---
  if ! command -v swappy &>/dev/null || ! command -v slurp &>/dev/null || ! command -v grim &>/dev/null; then
    echo "Error: Required Wayland tools (grim, slurp, swappy) are missing." >&2
    exit 1
  fi

  GEOMETRY=$(slurp -w 0)
  if [ -z "$GEOMETRY" ]; then
    echo "Screenshot selection aborted."
    exit 0
  fi
  grim -g "$GEOMETRY" -t png - 2>/dev/null | swappy -f -

else
  # --- X11 SESSION (i3) ---
  if ! command -v maim &>/dev/null || ! command -v slop &>/dev/null; then
    echo "Error: Required X11 tools (maim, slop) are missing." >&2
    exit 1
  fi

  # Crosshair appears instantly; drag to capture, or press Escape / Right-click to abort
  if maim -s "$FILE"; then
    if [ -f "$FILE" ] && [ -s "$FILE" ]; then
      echo "Screenshot saved to $FILE"
      # Copy to clipboard if xclip is available
      if command -v xclip &>/dev/null; then
        xclip -selection clipboard -t image/png <"$FILE"
      fi
    else
      echo "Screenshot selection aborted."
    fi
  else
    echo "Screenshot selection aborted."
    # Clean up any empty files if cancelled
    [ -f "$FILE" ] && rm -f "$FILE"
  fi
fi
