#!/usr/bin/env python3

"""
Set a random wallpaper from available collection
"""

import sys
from pathlib import Path

# Setup library path
sys.path.insert(0, str(Path(__file__).parent))
from lib.path_setup import setup_lib_path
setup_lib_path()

# Now import from organized modules
from lib.config import WallpaperConfig
from lib.services.wallpaper_manager import WallpaperManager
from lib.core.notifications import notify_error, notify_wallpaper_change
from lib.hyprland.lock_manager import hyprpaper_lock

def main():
    """Main function to set random wallpaper"""
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            config = WallpaperConfig()
            manager = WallpaperManager(config)
            result = manager.set_random_wallpaper()
            
            if result.success:
                notify_wallpaper_change(result.wallpaper_name)
                sys.exit(0)
            else:
                notify_error("Failed to set random wallpaper", result.error_message)
                sys.exit(1)
                
        except Exception as e:
            notify_error("Script error", f"Unexpected error: {str(e)}")
            sys.exit(1)


if __name__ == "__main__":
    main()