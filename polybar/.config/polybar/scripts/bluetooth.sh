#!/bin/sh
# Bluetooth icon for Polybar
# Off / Powered On / Connected

if ! command -v bluetoothctl >/dev/null 2>&1; then
  exit 0
fi

if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
  echo "%{F#75758a}%{T3}󰂲%{T-}%{F-}"
  exit 0
fi

for m in $( (bluetoothctl devices Connected 2>/dev/null || true) | awk '/^Device/{print $2}'); do
  echo "%{T3}󰂱%{T-}"
  exit 0
done

echo "%{T3}󰂯%{T-}"
