#!/usr/bin/env bash

# Configuration: Set to true to use tuned-adm, false for simple battery icon
USE_POWER_PROFILES=true

# This variable selects mode to run.
MODE=$1

# Power profile switcher
if [[ $MODE == "toggle" ]]; then
    if [[ $USE_POWER_PROFILES == "true" ]]; then
        PROFILE=$(tuned-adm active | awk '{print $NF}')
        if [[ $PROFILE == "laptop-battery-powersave" ]]; then
            tuned-adm profile balanced &
        elif [[ $PROFILE == "balanced" ]]; then
            tuned-adm profile throughput-performance &
        else
            tuned-adm profile laptop-battery-powersave &
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
        PROFILE=$(tuned-adm active | awk '{print $NF}')
        case "$PROFILE" in
            throughput-performance) PROFILE=$" 󰓅"
                ;;
            balanced) PROFILE=$" 󰾅"
                ;;
            laptop-battery-powersave) PROFILE=$" 󰾆"
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