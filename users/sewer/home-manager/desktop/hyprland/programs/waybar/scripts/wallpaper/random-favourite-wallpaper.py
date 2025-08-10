#!/usr/bin/env python3

"""
Set a random wallpaper from available collection
"""

import sys
import argparse
from pathlib import Path

# Setup library path
sys.path.insert(0, str(Path(__file__).parent))
from lib.path_setup import setup_lib_path
setup_lib_path()

# Now import from organized modules
from lib.config import WallpaperConfig
from lib.services.wallpaper_manager import WallpaperManager
from lib.core.notifications import notify_error, notify_wallpaper_change
from lib.core.collection_manager import CollectionManager
from lib.hyprland.lock_manager import hyprpaper_lock
from lib.hyprland.screen_utils import get_search_resolution

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(description='Set a random wallpaper from available collection')
    parser.add_argument(
        '--aspect-ratio-mode',
        choices=['similar', 'any'],
        default='similar',
        help='Aspect ratio filtering mode: "similar" matches monitor ratios, "any" allows all ratios (default: similar)'
    )
    return parser.parse_args()

def main():
    """Main function to set random wallpaper"""
    # Parse command line arguments
    args = parse_arguments()
    
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            config = WallpaperConfig()
            manager = WallpaperManager(config)
            collection_manager = CollectionManager(config)
            
            # Get optimal resolution for current monitors
            resolution = get_search_resolution()
            result = manager.set_random_wallpaper(min_resolution=resolution, aspect_ratio_mode=args.aspect_ratio_mode)
            
            if result.success:
                # Get wallpaper name without extension and resolution info
                wallpaper_name_no_ext = result.wallpaper_path.stem if result.wallpaper_path else "Unknown"
                wallpaper_resolution = None
                
                # Try to get resolution from collection manager
                if result.wallpaper_path:
                    wallpaper_info = collection_manager.get_wallpaper_info(result.wallpaper_path.stem)
                    if wallpaper_info:
                        wallpaper_resolution = wallpaper_info.get('resolution')
                
                notify_wallpaper_change(wallpaper_name_no_ext, wallpaper_resolution)
                sys.exit(0)
            else:
                notify_error("Failed to set random wallpaper", result.error_message)
                sys.exit(1)
                
        except Exception as e:
            notify_error("Script error", f"Unexpected error: {str(e)}")
            sys.exit(1)


if __name__ == "__main__":
    main()