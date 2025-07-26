#!/usr/bin/env python3

"""
Set favourite wallpaper (to be implemented)
"""

import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.wallpaper import WallpaperManager
from lib.notifications import notify_error, notify_wallpaper_change

def main():
    """Main function to set favourite wallpaper"""
    try:
        manager = WallpaperManager()
        
        # TODO: Implement favourite wallpaper logic
        # For now, just set a random wallpaper with notification
        result = manager.set_random_wallpaper()
        
        if result.success:
            notify_wallpaper_change(result.wallpaper_name)
            sys.exit(0)
        else:
            notify_error("Failed to set favourite wallpaper", result.error_message)
            sys.exit(1)
            
    except Exception as e:
        notify_error("Script error", f"Unexpected error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()