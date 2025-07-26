#!/usr/bin/env python3

"""
Startup wallpaper script for Hyprland
Sets a random wallpaper at startup and initiates background sync
"""

import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.wallpaper import WallpaperManager
from lib.wallhaven import WallhavenManager
from lib.notifications import notify_success, notify_error, notify_wallpaper_change

def main():
    """Main function to set startup wallpaper and sync collection"""
    try:
        manager = WallpaperManager()
        
        # Set random wallpaper from existing cache first
        wallpaper_result = manager.set_random_wallpaper()
        
        if wallpaper_result.success:
            notify_wallpaper_change(wallpaper_result.wallpaper_name)
        else:
            notify_error("No cached wallpapers found", "Will sync collection to download wallpapers")
        
        # Start Wallhaven collection sync
        wallhaven = WallhavenManager()
        sync_result = wallhaven.sync_collection()
        
        if sync_result.success:
            if sync_result.downloaded_count > 0:
                notify_success("Wallpaper sync completed", sync_result.summary())
            # If no new downloads but sync was successful, don't notify (collection is up to date)
        else:
            notify_error("Wallpaper sync failed", sync_result.errors[0] if sync_result.errors else "Unknown error")
        
        # Exit successfully regardless of wallpaper result to not fail startup
        sys.exit(0)
        
    except Exception as e:
        notify_error("Startup script error", f"Unexpected error: {str(e)}")
        sys.exit(0)  # Don't fail startup even on errors


if __name__ == "__main__":
    main()