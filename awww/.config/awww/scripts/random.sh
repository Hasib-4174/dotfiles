#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

awww img "$RANDOM_WALLPAPER" \
    --transition-type random \
    --transition-duration=1.5 \
    --transition-step 60 \
    --transition-fps 60
