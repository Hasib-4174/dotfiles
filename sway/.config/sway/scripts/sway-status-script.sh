#!/usr/bin/env bash
#
# Sway Status Script - Modularized for swaybar status_command

# --- Configuration ---
# Set the root path for storage checks
STORAGE_PATH="/"
# Set the separator color (matching sway config's separator color #a6e3a1)
SEP_COLOR="#a6e3a1" 

# --- MODULE FUNCTIONS (RIGHT SIDE) ---

# 1. Power Button (Rightmost)
function print_power() {
    # Output the JSON block
    printf '{"full_text": "  ", "color": "#f28fad", "separator_block_width": 10, "name": "power", "on-click": "wlogout"}'
}

# 2. Date and Time
function print_datetime() {
    local date_time
    date_time="$(date +"%a %b %d | %H:%M")"
    printf '{"full_text": " %s ", "color": "#a6e3a1", "separator": true, "separator_block_width": 10}' "$date_time"
}

# ... (rest of the script remains the same)

# 3. Storage (MODIFIED)
function print_storage() {
    local used_gb total_gb color
    
    # Get total and used space in GB for the root partition
    # df output: Filesystem 1K-blocks Used Available Use% Mounted on
    # Convert 1K-blocks to GB (divide by 1024*1024)
    read -r total_gb used_gb <<< $(df -T --output=size,used $STORAGE_PATH | awk 'NR==2{print $1/1024/1024, $2/1024/1024}')
    
    # Calculate usage percentage for color coding
    local used_percent=$(df -hP $STORAGE_PATH | awk 'NR==2 {print $5}' | sed 's/%//')
    
    local color="#94e2d5"
    if [ "$used_percent" -gt 80 ]; then
        color="#fab387" # Orange for high usage
    fi

    # Format output: Used / Total (e.g., 25.1GiB / 50.0GiB)
    printf '{"full_text": "  %.1fGiB / %.1fGiB ", "color": "%s", "separator": true, "separator_block_width": 10}' \
        "$used_gb" "$total_gb" "$color"
}

# 4. RAM (Memory) (MODIFIED)
function print_memory() {
    local used_mb total_mb free_mb used_gb total_gb color
    
    # Get total, used, and free memory in MB
    # free output: Mem: total used free shared buff/cache available
    read -r total_mb used_mb <<< $(free -m | awk 'NR==2{print $2, $3}')
    
    # Convert MB to GB for readable output
    total_gb=$(echo "scale=1; $total_mb / 1024" | bc)
    used_gb=$(echo "scale=1; $used_mb / 1024" | bc)

    # Calculate percentage for color coding (used * 100 / total)
    local used_percent=$(echo "scale=0; $used_mb * 100 / $total_mb" | bc)

    local color="#94e2d5"
    if [ "$used_percent" -gt 80 ]; then
        color="#fab387" # Orange for high usage
    fi

    # Format output: Used / Total (e.g., 5.2GiB / 16.0GiB)
    printf '{"full_text": " M %.1fGiB / %.1fGiB ", "color": "%s", "separator": true, "separator_block_width": 10}' \
        "$used_gb" "$total_gb" "$color"
}

# 5. CPU
function print_cpu() {
    local cpu_usage
    # Get CPU usage percentage from the last 1 second
    cpu_usage=$(grep 'cpu ' /proc/stat | awk '{print ($2+$4)*100/($2+$4+$5)}' | awk '{printf "%.0f\n", $1}')

    printf '{"full_text": "  %s%% ", "color": "#94e2d5", "separator": true, "separator_block_width": 10}' "$cpu_usage"
}

# 6. Volume
function print_volume() {
    local vol status
    # Get current volume level and mute status
    status=$(amixer get Master | awk '/Mono|Front Left:/ {print $NF}' | tail -n 1)
    vol=$(amixer get Master | awk -F'[][]' '/dB/ {print $2}' | tail -n 1 | sed 's/%//')
    
    if [ "$status" = "[off]" ]; then
        printf '{"full_text": "  Muted ", "color": "#f38ba8", "separator": true, "separator_block_width": 10, "on_click": "pactl set-sink-mute @DEFAULT_SINK@ toggle"}'
    else
        local icon
        if [ "$vol" -lt 30 ]; then
            icon=""
        elif [ "$vol" -lt 60 ]; then
            icon=""
        else
            icon=""
        fi
        printf '{"full_text": " %s %s%% ", "color": "#f5e0dc", "separator": true, "separator_block_width": 10, "on_click": "pactl set-sink-mute @DEFAULT_SINK@ toggle"}' "$icon" "$vol"
    fi
}

# 7. Battery
function print_battery() {
    local capacity status icon color

    # Get battery info from sysfs
    capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
    state=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)

    # Check if a battery exists
    if [ -z "$capacity" ]; then
        # If no battery, only show a subtle indicator (e.g., for desktop)
        printf '{"full_text": "  AC ", "color": "#a6e3a1", "separator": true, "separator_block_width": 10}'
        return
    fi
    
    # Set icon and color based on state/capacity
    if [ "$state" = "Charging" ]; then
        icon=""
        color="#a6e3a1"
    elif [ "$state" = "Full" ]; then
        icon=""
        color="#a6e3a1"
    else
        if [ "$capacity" -le 10 ]; then
            icon=""
            color="#f38ba8" # Critical (Pink/Red)
        elif [ "$capacity" -le 20 ]; then
            icon=""
            color="#fab387" # Warning (Orange)
        elif [ "$capacity" -le 60 ]; then
            icon=""
            color="#b4befe" # Normal (Lavender)
        else
            icon=""
            color="#b4befe"
        fi
    fi

    printf '{"full_text": " %s %s%% ", "color": "%s", "separator": true, "separator_block_width": 10}' "$icon" "$capacity" "$color"
}


# --- MODULE FUNCTIONS (LEFT SIDE - Custom/App Icons) ---
# NOTE: Native swaybar does not easily support app icons or a dynamic custom left block 
# outside of its built-in modules (workspaces, window title, binding mode).
# We will use the 'sway/mode' concept as a custom logo/launcher placeholder.

function print_logo() {
    # Custom Logo/Launcher: Leftmost block
    # Note: swaybar doesn't natively support left-side modules in the status JSON.
    # We will use the 'sway/mode' or 'sway/window' feature to show something, 
    # but the status JSON only shows on the right.
    # For the status script, this module will be empty or a simple separator if needed.
    :
}


# --- MAIN LOOP ---

# Start continuous output required by swaybar's status_command
echo '{ "version": 1 }'
echo '['
echo '[]'

while true; do
    # 1. Gather all right-side module outputs in reverse order (to display correctly right-aligned)
    # The output is a comma-separated JSON array.

    
    # 9. Date/Time
    STATUS_JSON+="$(print_datetime),"
    
    # 8. Storage
    STATUS_JSON+="$(print_storage),"
    
    # 7. RAM
    STATUS_JSON+="$(print_memory),"
    
    # 6. CPU
    STATUS_JSON+="$(print_cpu),"
    
    # 5. Volume
    STATUS_JSON+="$(print_volume),"
    
    # 4. Battery (Leftmost of the right block)
    STATUS_JSON+="$(print_battery),"

    # 10. Power button (Rightmost)
    STATUS_JSON+="$(print_power)"

    # 2. Print the final combined JSON array
    # We wrap the content in a single array and print it.
    echo ", [${STATUS_JSON}]"
    
    # 3. Clean the variable and wait
    unset STATUS_JSON
    sleep 1
done
