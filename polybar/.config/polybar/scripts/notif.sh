#!/bin/sh
# Notification icon for Polybar
# Supports dunst / swaync if available, otherwise clean notification glyph

if command -v dunstctl >/dev/null 2>&1; then
  if [ "$(dunstctl is-paused 2>/dev/null)" = "true" ]; then
    n=$(dunstctl count waiting 2>/dev/null)
    [ "${n:-0}" -gt 0 ] && echo "󰂛 $n" || echo "󰂛"
  else
    echo "󰂚"
  fi
elif command -v swaync-client >/dev/null 2>&1; then
  if [ "$(swaync-client -D 2>/dev/null)" = "true" ]; then
    echo "󰂛"
  else
    echo "󰂚"
  fi
else
  echo "󰂚"
fi
