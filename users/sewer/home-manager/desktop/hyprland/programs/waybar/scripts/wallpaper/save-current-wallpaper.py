#!/usr/bin/env python3

"""
Save the current wallpaper to the saved collection with JXL conversion
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
from lib.core.notifications import notify_error, notify_success
from lib.core.collection_manager import CollectionManager
from lib.core.file_utils import get_image_resolution
from lib.hyprland.lock_manager import hyprpaper_lock


def main():
    """Main function to save current wallpaper"""
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            # Create config
            config = WallpaperConfig()
            manager = WallpaperManager(config)
            
            # Check if current wallpaper is a downloaded one (from temp directory)
            current_wallpaper = manager.get_current_wallpaper()
            if not current_wallpaper:
                notify_error("No wallpaper set", "No current wallpaper to save")
                sys.exit(1)
            
            # Only allow saving if the wallpaper is from the current random directory
            current_random_dir = config.current_random_dir
            try:
                # Check if current wallpaper is in current random directory
                current_wallpaper.relative_to(current_random_dir)
            except ValueError:
                # Wallpaper is not in current random directory - it's not a downloaded wallpaper
                notify_error("Cannot save wallpaper", "Only downloaded wallpapers can be saved")
                sys.exit(1)
            
            result = manager.save_current_wallpaper()
            
            if result.success:
                wallpaper_name = result.wallpaper_path.name if result.wallpaper_path else "Unknown"
                
                # Add to collection
                try:
                    collection_manager = CollectionManager(config)
                    
                    # Extract wallpaper ID from filename (stem removes extension)
                    wallpaper_id = result.wallpaper_path.stem
                    
                    # Get actual resolution from the image file
                    resolution = get_image_resolution(result.wallpaper_path) or "unknown"
                    
                    # Get file extension
                    file_extension = result.wallpaper_path.suffix
                    
                    collection_manager.add_wallpaper(
                        wallpaper_id=wallpaper_id,
                        resolution=resolution,
                        file_extension=file_extension
                    )
                except Exception:
                    # Don't fail the save if collection update fails
                    pass
                
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