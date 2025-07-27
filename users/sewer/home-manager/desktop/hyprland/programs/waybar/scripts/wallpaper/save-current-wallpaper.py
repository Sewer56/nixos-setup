#!/usr/bin/env python3

"""
Save the current wallpaper to the saved collection with JXL conversion
"""

import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.wallpaper import WallpaperManager
from lib.notifications import notify_error, notify_success
from lib.lock_manager import hyprpaper_lock


def main():
    """Main function to save current wallpaper"""
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            manager = WallpaperManager()
            
            # Check if current wallpaper is a downloaded one (from temp directory)
            current_wallpaper = manager.get_current_wallpaper()
            if not current_wallpaper:
                notify_error("No wallpaper set", "No current wallpaper to save")
                sys.exit(1)
            
            # Only allow saving if the wallpaper is from the temp directory
            temp_dir = Path.home() / "Pictures" / "wallpapers" / "temp"
            try:
                # Check if current wallpaper is in temp directory
                current_wallpaper.relative_to(temp_dir)
            except ValueError:
                # Wallpaper is not in temp directory - it's not a downloaded wallpaper
                notify_error("Cannot save wallpaper", "Only downloaded wallpapers can be saved")
                sys.exit(1)
            
            result = manager.save_current_wallpaper()
            
            if result.success:
                wallpaper_name = result.wallpaper_path.name if result.wallpaper_path else "Unknown"
                notify_success("Wallpaper saved", f"Saved: {wallpaper_name}")
                sys.exit(0)
            else:
                notify_error("Failed to save wallpaper", result.error_message)
                sys.exit(1)
                
        except Exception as e:
            notify_error("Script error", f"Unexpected error: {str(e)}")
            sys.exit(1)


if __name__ == "__main__":
    main()