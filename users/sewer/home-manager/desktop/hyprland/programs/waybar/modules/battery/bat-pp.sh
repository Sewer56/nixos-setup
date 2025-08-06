#!/usr/bin/env bash

# Configuration: Set to true to use powerprofilesctl, false for simple battery icon
USE_POWER_PROFILES=false

# This variable selects mode to run.
MODE=$1

# Power profile switcher
if [[ $MODE == "toggle" ]]; then
    if [[ $USE_POWER_PROFILES == "true" ]]; then
        PROFILE=$(powerprofilesctl get)
        if [[ $PROFILE == "power-saver" ]]; then
            powerprofilesctl set balanced &
        elif [[ $PROFILE == "balanced" ]]; then
            powerprofilesctl set performance &
        else
            powerprofilesctl set power-saver &
        fi
    fi
    # When USE_POWER_PROFILES is false, this is a no-op
fi

# Refreshes the whole module.
if [[ $MODE == "refresh" ]]; then

    # Delay, so that powerprofile switches first.
    # Increase if doesn't update on click.
    sleep 0.25

    # Get battery information.
    BATTERY=$(upower -e | grep 'BAT')
    PERCENT=$(upower -i "$BATTERY" | awk '/percentage/ {print $2}' | tr -d '%')
    STATE=$(upower -i "$BATTERY" | awk '/state/ {print $2}' | tr -d '%')
    RATE=$(upower -i "$BATTERY" | awk '/energy-rate/ {print $2}' | tr -d '%')

    # Set class for styling.
    if [[ $STATE == "charging" ]]; then
        CLASS=$"charging"
    elif [[ $PERCENT -le 10 ]]; then
        CLASS=$"critical"
    elif [[ $PERCENT -le 20 ]]; then
        CLASS=$"warning"
    else
        CLASS=$"normal"
    fi

    # Set energy rate polarity.
    if [[ $STATE == "charging" ]]; then
        TOOLTIP="+$RATE"
    else
        TOOLTIP=$"-$RATE"
    fi

    # Choose display mode based on configuration
    if [[ $USE_POWER_PROFILES == "true" ]]; then
        # Get power profile and format icon.
        # Nerd font used in this case.
        PROFILE=$(powerprofilesctl get)
        case "$PROFILE" in
            performance) PROFILE=$" 󰓅"
                ;;
            balanced) PROFILE=$" 󰾅"
                ;;
            power-saver) PROFILE=$" 󰾆"
                ;;
        esac
        DISPLAY_TEXT="$PROFILE $PERCENT"
    else
        # Simple battery icon (replacing power profile icons)
        # Nerd font battery icon
        BATTERY_ICON="󰁹"
        DISPLAY_TEXT="$BATTERY_ICON $PERCENT"
    fi

    # Export as json.
    printf '{"text": "%s", "class": "%s", "alt": "%s"}\n' "$DISPLAY_TEXT" "$CLASS" "$TOOLTIP"
fi

# Indicator bar
if [[ $MODE == "bar" ]]; then
    BATTERY=$(upower -e | grep 'BAT')
    PERCENT=$(upower -i "$BATTERY" | awk '/percentage/ {print $2}' | tr -d '%')
    STATE=$(upower -i "$BATTERY" | awk '/state/ {print $2}' | tr -d '%')

    # Set class for styling.
    if [[ $STATE == "fully-charged" ]]; then
        CLASS=$"full"
    elif [[ $STATE == "charging" ]]; then
        CLASS=$"charging"
    elif [[ $PERCENT -le 10 ]]; then
        CLASS=$"critical"
    elif [[ $PERCENT -le 20 ]]; then
        CLASS=$"warning"
    else
        CLASS=$"discharging"
    fi

    # Export as json.
    printf '{"class": "%s"}\n' "$CLASS"
fi