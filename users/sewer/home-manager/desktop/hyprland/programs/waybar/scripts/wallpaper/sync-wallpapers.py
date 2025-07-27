#!/usr/bin/env python3

"""
Wallpaper collection sync script for Hyprland
Downloads and syncs wallpapers from Wallhaven collection
"""

import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.wallhaven import WallhavenManager
from lib.notifications import notify_success, notify_error

def main():
    """Main function to sync wallpaper collection"""
    try:
        # Start Wallhaven collection sync
        wallhaven = WallhavenManager()
        sync_result = wallhaven.sync_collection()
        
        if sync_result.success:
            if sync_result.downloaded_count > 0:
                notify_success("Wallpaper sync completed", sync_result.summary())
            else:
                notify_success("Collection up to date", "No new wallpapers to download")
        else:
            notify_error("Wallpaper sync failed", sync_result.errors[0] if sync_result.errors else "Unknown error")
            sys.exit(1)
        
        sys.exit(0)
        
    except Exception as e:
        notify_error("Sync script error", f"Unexpected error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()