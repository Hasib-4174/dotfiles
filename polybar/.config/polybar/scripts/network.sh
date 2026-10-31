#!/bin/sh
# Network IP and icon for Polybar
# Click action: alacritty -e nmtui

# Check Ethernet first
ETH=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$2=="ethernet" && $3=="connected"{print $1; exit}')
if [ -n "$ETH" ]; then
  IP=$(ip -4 -o addr show dev "$ETH" scope global 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -1)
  echo "%{T3}󰈀%{T-} ${IP:-Connected}"
  exit 0
fi

# Check Wi-Fi
WIFI=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$2=="wifi" && $3=="connected"{print $1; exit}')
if [ -n "$WIFI" ]; then
  IP=$(ip -4 -o addr show dev "$WIFI" scope global 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -1)
  SIG=$(nmcli -t -f IN-USE,SIGNAL device wifi list ifname "$WIFI" 2>/dev/null | awk -F: '/^\*/{print $2; exit}')
  case "${SIG:-0}" in
    ''|*[!0-9]*) SIG=0 ;;
  esac
  GLYPH=󰤨
  [ "$SIG" -lt 80 ] && GLYPH=󰤥
  [ "$SIG" -lt 60 ] && GLYPH=󰤦
  [ "$SIG" -lt 40 ] && GLYPH=󰤧
  [ "$SIG" -lt 20 ] && GLYPH=󰤠
  echo "%{T3}$GLYPH%{T-} ${IP:-Connected}"
  exit 0
fi

# Disconnected
echo "%{T3}󰖪%{T-} Disconnected"
