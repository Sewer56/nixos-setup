#!/usr/bin/env python3

"""
Set favourite colour wallpaper (to be implemented)
"""

import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.wallpaper import WallpaperManager
from lib.notifications import notify_error, notify_wallpaper_change
from lib.lock_manager import hyprpaper_lock

def main():
    """Main function to set favourite colour wallpaper"""
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            manager = WallpaperManager()
            
            # TODO: Implement favourite colour wallpaper logic
            # For now, just set a random wallpaper with notification
            result = manager.set_random_wallpaper()
            
            if result.success:
                notify_wallpaper_change(result.wallpaper_name)
                sys.exit(0)
            else:
                notify_error("Failed to set favourite colour wallpaper", result.error_message)
                sys.exit(1)
                
        except Exception as e:
            notify_error("Script error", f"Unexpected error: {str(e)}")
            sys.exit(1)


if __name__ == "__main__":
    main()