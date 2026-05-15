
#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# start daemon

if ! pgrep -x awww-daemon > /dev/null
then
    echo "Starting awww-daemon..."
    awww-daemon &
    sleep 1
fi

# set initial wallpaper

RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

awww img "$RANDOM_WALLPAPER" \
    --transition-type wipe \
    --transition-step 90 \
    --transition-duration=1.5 \
    --transition-fps 60
