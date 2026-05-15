#!/bin/bash

# App names' mapping to icons 
# Icons:  󰈹  
declare -A icons=(
  ["brave-browser"]="󰈹"
  ["firefox-developer-edition"]=""
  ["firefox"]=""
  ["google-chrome"]=""
  ["chromium"]=""
  ["Alacritty"]=""
  ["foot"]=""
  ["kitty"]=""
  ["Code"]="󰨞"
  ["dev.zed.Zed"]=""
  ["GitKraken"]=""
  ["org.kde.dolphin"]=""
  ["org.telegram.desktop"]=""
  ["thunar"]=""
  ["pcmanfm"]=" "
  ["vlc"]=""
  ["mpv"]=""
  ["imv"]=""
  ["discord"]=""
  ["steam"]=""
  ["spotify"]=""
  ["jetbrains-studio"]=""
  ["Antigravity"]="󰠄"
  ["libreoffice-writer"]=""
  ["minecraft"]="󰍳"
  ["virt-manager"]=""
  ["com.obsproject.Studio"]="󱜏"
  ["blender"]="󰂫"
)

# Get all visible windows in the current workspace
#hyprctl clients -j | jq -r '.[] | .class'
hyprctl clients -j | jq -r '.[] | select(.workspace.id != -1 and .workspace.id == .workspace.id) | .class' |
  awk '!seen[$0]++' |
  while read -r app; do
    icon="${icons[$app]}"
    if [ -n "$icon" ]; then
      echo -n "$icon  "
    else
      echo -n "  " # fallback icon
    fi
  done

echo
