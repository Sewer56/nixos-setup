#!/usr/bin/env python3

"""Shared constants for wallpaper management"""

# User agent for HTTP requests
USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'

# Default paths (can be overridden via config)
DEFAULT_WALLPAPER_DIR = "~/Pictures/wallpapers"
DEFAULT_SUBDIRS = {
    'saved': 'saved',
    'temp': 'temp'
}

# File extensions
SUPPORTED_EXTENSIONS = {'.jxl', '.jpg', '.jpeg', '.png', '.webp'}

# API limits
WALLHAVEN_RATE_LIMIT = 45
WALLHAVEN_RATE_LIMIT_WINDOW = 60
DEFAULT_TIMEOUT = 60