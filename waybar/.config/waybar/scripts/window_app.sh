
#!/bin/bash

# Get active window's app (class) name using hyprctl
app=$(hyprctl activewindow -j | jq -r '.class')

# Fallback in case it fails
echo "${app:-Unknown}"
