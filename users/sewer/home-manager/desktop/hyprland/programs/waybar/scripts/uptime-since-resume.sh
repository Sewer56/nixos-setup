#!/usr/bin/env bash
# Script to calculate uptime since last resume from suspend/hibernate
# Used by waybar uptime widget

TIMESTAMP_FILE="/var/log/last-resume"

# Function to format seconds into human-readable time
format_time() {
    local seconds=$1
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    
    if [ $hours -gt 0 ]; then
        echo "${hours}h ${minutes}m"
    elif [ $minutes -gt 0 ]; then
        echo "${minutes}m"
    else
        echo "<1m"
    fi
}

# Check if timestamp file exists and is readable
if [ -f "$TIMESTAMP_FILE" ] && [ -r "$TIMESTAMP_FILE" ]; then
    # Read the last resume timestamp
    last_resume=$(cat "$TIMESTAMP_FILE" 2>/dev/null)
    
    # Validate that we got a number
    if [[ "$last_resume" =~ ^[0-9]+$ ]]; then
        current_time=$(date '+%s')
        uptime_seconds=$((current_time - last_resume))
        
        # Only show if uptime is positive (sanity check)
        if [ $uptime_seconds -ge 0 ]; then
            format_time $uptime_seconds
            exit 0
        fi
    fi
fi

# Fallback: show time since boot if no resume file or error
boot_time=$(cut -d. -f1 /proc/uptime)
format_time $boot_time