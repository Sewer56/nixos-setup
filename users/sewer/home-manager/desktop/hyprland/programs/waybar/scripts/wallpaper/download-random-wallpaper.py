#!/usr/bin/env python3

"""
Download and set a random wallpaper from Wallhaven
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
from lib.services.wallpaper_prefetch import WallpaperPrefetch
from lib.wallhaven.client import WallhavenClient
from lib.wallhaven.search import WallhavenSearch
from lib.wallhaven.downloader import WallpaperDownloader
from lib.core.cache_manager import CacheManager
from lib.core.metadata_utils import get_wallpaper_display_info
from lib.hyprland.screen_utils import get_search_resolution
from lib.core.notifications import notify_error, notify_wallpaper_change, notify_info
from lib.hyprland.lock_manager import hyprpaper_lock

# Search parameters configuration
SEARCH_PARAMS = {
    'categories': '110',        # general + anime
    'purity': '100',            # SFW only
    'max_items': 10000,         # Maximum number of wallpapers to consider
    'percentage_of_items': 0.1, # 10% of available wallpapers
}

def handle_prefetched_wallpaper(config: WallpaperConfig, prefetch: WallpaperPrefetch, resolution: str) -> bool:
    """Handle case where prefetched wallpaper is available"""
    # Use prefetched wallpaper for instant switching
    wallpaper_path = prefetch.move_prefetched_to_current()
    
    if not wallpaper_path:
        return False  # Failed to get prefetched wallpaper
    
    # Initialize shared components for prefetch
    api = WallhavenClient()
    cache = CacheManager()
    search = WallhavenSearch(api, cache, config.cache_max_age_days)
    downloader = WallpaperDownloader(config)
    
    # Start prefetch BEFORE setting wallpaper for parallel execution
    search_params = {
        'min_resolution': resolution,
        **SEARCH_PARAMS
    }
    prefetch_thread = prefetch.start_background_prefetch(
        search_params, search, downloader
    )
    
    # Set wallpaper while prefetch runs in parallel
    manager = WallpaperManager(config)
    result = manager.set_wallpaper(wallpaper_path)
    
    if result.success:
        # Get wallpaper display info for notification
        display_info = get_wallpaper_display_info(wallpaper_path)
        
        # Format resolution string with category if available
        resolution_str = display_info['resolution']
        if display_info['category']:
            resolution_str = f"{resolution_str} • {display_info['category']}" if resolution_str else display_info['category']
        
        notify_wallpaper_change(display_info['name'], resolution_str)
        # Wait for prefetch to complete before exiting
        prefetch_thread.join()
        sys.exit(0)
    else:
        notify_error("Failed to set wallpaper", result.error_message)
        # Wait for prefetch anyway to avoid killing thread
        prefetch_thread.join()
        return False  # Fall through to regular download


def handle_regular_download(config: WallpaperConfig, prefetch: WallpaperPrefetch, resolution: str) -> None:
    """Handle case where no prefetched wallpaper is available"""
    # Initialize components
    api = WallhavenClient()
    cache = CacheManager()
    search = WallhavenSearch(api, cache, config.cache_max_age_days)
    downloader = WallpaperDownloader(config)
    
    # Clear any previous temp downloads
    downloader.clear_download_temp_directory()
    
    # Clean expired cache entries
    cache.clear(max_age_days=config.cache_max_age_days)
    
    # Show searching notification
    notify_info(f"Searching Wallhaven\nFinding wallpapers ≥{resolution}")
    
    # Search for a random wallpaper
    wallpaper_data = search.search_random_wallpaper(
        min_resolution=resolution,
        **SEARCH_PARAMS
    )
    
    if not wallpaper_data:
        notify_error("Search failed", "No wallpapers found matching criteria")
        sys.exit(1)
    
    # Clear current directory before downloading new wallpaper
    downloader.clear_current_random_directory()
    
    # Download directly to current_random_dir
    download_result = downloader.download_wallpaper(
        wallpaper_data, 
        target_dir=config.current_random_dir
    )
    
    if not download_result.success:
        notify_error("Download failed", download_result.error_message)
        sys.exit(1)
    
    # Start prefetch BEFORE setting wallpaper for parallel execution
    search_params = {
        'min_resolution': resolution,
        **SEARCH_PARAMS
    }
    prefetch_thread = prefetch.start_background_prefetch(
        search_params, search, downloader
    )
    
    # Set wallpaper while prefetch runs in parallel
    manager = WallpaperManager(config)
    result = manager.set_wallpaper(download_result.file_path)
    
    if result.success:
        # Get wallpaper info for notification
        wallpaper_id = wallpaper_data.get('id', 'unknown')
        resolution_info = wallpaper_data.get('resolution', '')
        category = wallpaper_data.get('category', 'unknown')
        
        # Format resolution string with category
        resolution_str = f"{resolution_info} • {category}" if resolution_info else category
        
        notify_wallpaper_change(wallpaper_id, resolution_str)
        
        # Wait for prefetch to complete before exiting
        prefetch_thread.join()
        sys.exit(0)
    else:
        notify_error("Failed to set wallpaper", result.error_message)
        # Wait for prefetch anyway to avoid killing thread
        prefetch_thread.join()
        sys.exit(1)


# TODO: Add function to set per monitor wallpaper, rather than all same monitor.
def main() -> None:
    """Main function to download and set random wallpaper with prefetching"""
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            # Create config with custom paths if needed
            config = WallpaperConfig()
            
            # Get optimal search resolution for all monitors
            resolution = get_search_resolution()
            
            # Initialize prefetch service
            prefetch = WallpaperPrefetch(config)
            
            # Check if we have a prefetched wallpaper available
            if prefetch.has_prefetched_wallpaper():
                # Try to use prefetched wallpaper
                if handle_prefetched_wallpaper(config, prefetch, resolution):
                    return  # Success, already exited
                # Fall through to regular download if prefetched failed
            
            # No prefetched wallpaper available or prefetched failed
            handle_regular_download(config, prefetch, resolution)

        except Exception as e:
            notify_error("Script error", f"Unexpected error: {str(e)}")
            sys.exit(1)


if __name__ == "__main__":
    main()