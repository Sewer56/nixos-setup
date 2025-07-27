#!/usr/bin/env python3

"""
Download and set a random wallpaper from Wallhaven
"""

import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.wallpaper import WallpaperManager
from lib.wallhaven_api import WallhavenAPI
from lib.wallhaven_search import WallhavenSearch, WallpaperDownloader
from lib.cache_manager import CacheManager
from lib.screen_utils import get_screen_resolution
from lib.notifications import notify_error, notify_wallpaper_change, notify_info
from lib.lock_manager import hyprpaper_lock


def main():
    """Main function to download and set random wallpaper"""
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            # Get current screen resolution
            resolution = get_screen_resolution()
            
            # Initialize components
            api = WallhavenAPI()
            cache = CacheManager()
            search = WallhavenSearch(api, cache)
            
            # Use temp directory for temporary downloads
            temp_dir = Path.home() / "Pictures" / "wallpapers" / "temp"
            downloader = WallpaperDownloader(download_dir=temp_dir)
            
            # Clear any previous temp wallpapers
            downloader.clear_temp_directory()
            
            # Clean expired cache entries (older than 7 days)
            cache.clear(max_age_days=7)
            
            # Show searching notification
            notify_info(f"Searching Wallhaven\nFinding wallpapers ≥{resolution}")
            
            # Search for a random wallpaper
            wallpaper_data = search.search_random_wallpaper(
                min_resolution=resolution,
                categories='110',  # general + anime
                purity='100'       # SFW only
            )
            
            if not wallpaper_data:
                notify_error("Search failed", "No wallpapers found matching criteria")
                sys.exit(1)
            
            # Download the wallpaper
            download_result = downloader.download_wallpaper(wallpaper_data)
            
            if not download_result.success:
                notify_error("Download failed", download_result.error_message)
                sys.exit(1)
            
            # Set as wallpaper
            manager = WallpaperManager()
            result = manager.set_wallpaper(download_result.file_path)
            
            if result.success:
                # Get wallpaper info for notification
                wallpaper_id = wallpaper_data.get('id', 'unknown')
                resolution_info = wallpaper_data.get('resolution', '')
                category = wallpaper_data.get('category', 'unknown')
                
                status = "Downloaded" if not download_result.was_cached else "Cached"
                
                notify_wallpaper_change(
                    f"{status}: {wallpaper_id}\n{resolution_info} • {category}"
                )
                sys.exit(0)
            else:
                notify_error("Failed to set wallpaper", result.error_message)
                sys.exit(1)
                
        except Exception as e:
            notify_error("Script error", f"Unexpected error: {str(e)}")
            sys.exit(1)


if __name__ == "__main__":
    main()