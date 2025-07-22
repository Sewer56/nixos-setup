#!/usr/bin/env bash
# Purpose: Increase microphone volume by 5%
# Used by waybar audio input controls

wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+