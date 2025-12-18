#!/bin/sh

# =============================================================================
# Sway Idle Management Script
# =============================================================================
# This script handles screen locking and power management (turning off screens).
# It uses 'swayidle' to detect inactivity and 'hyprlock' to lock the screen.
# =============================================================================

# 1. Define the location of your custom Hyprlock configuration file.
#    We use this variable so we don't have to type the path multiple times.
LOCK_CONFIG="$HOME/.config/sway/hyprlock.conf"

# 2. Run swayidle
#    '-w' tells swayidle to wait for commands to finish before continuing.
exec swayidle -w \
    \
    # --- IDLE EVENT 1: LOCK SCREEN (5 Minutes) ---
    # After 300 seconds (5 mins), run hyprlock using your custom config file.
    timeout 300 "hyprlock -c $LOCK_CONFIG" \
    \
    # --- IDLE EVENT 2: SCREEN OFF (10 Minutes) ---
    # After 600 seconds (10 mins), tell Sway to turn off all monitors (DPMS).
    timeout 600 'swaymsg "output * dpms off"' \
    \
    # --- RESUME EVENT: SCREEN ON ---
    # When you move the mouse or press a key, turn the monitors back on.
    resume 'swaymsg "output * dpms on"' \
    \
    # --- SYSTEM SLEEP EVENT ---
    # Before the computer goes to sleep (suspend), lock the screen immediately.
    before-sleep "hyprlock -c $LOCK_CONFIG"
