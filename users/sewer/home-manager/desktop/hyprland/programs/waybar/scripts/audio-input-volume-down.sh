#!/usr/bin/env bash
# Purpose: Decrease microphone volume by 0.1%
# Used by waybar audio input controls

wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.1%-