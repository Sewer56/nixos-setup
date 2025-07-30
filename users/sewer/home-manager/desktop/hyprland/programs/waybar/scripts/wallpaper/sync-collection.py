#!/usr/bin/env python3

"""
Sync wallpaper collection - download missing wallpapers
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from lib.path_setup import setup_lib_path
setup_lib_path()

from lib.config import WallpaperConfig
from lib.services.collection_sync_service import CollectionSyncService
from lib.core.notifications import notify_success, notify_error, notify_info

def main():
    """Main function to sync wallpaper collection"""
    try:
        notify_info("Collection sync started - Checking for missing wallpapers...")
        
        config = WallpaperConfig()
        sync_service = CollectionSyncService(config)
        result = sync_service.sync_missing_wallpapers()
        
        if result.success:
            if result.downloaded_count > 0:
                notify_success("Sync completed", f"Downloaded {result.downloaded_count} wallpapers")
            else:
                notify_success("Collection complete", "No missing wallpapers found")
        else:
            notify_error("Sync failed", result.errors[0] if result.errors else "Unknown error")
            sys.exit(1)
            
    except Exception as e:
        notify_error("Sync error", str(e))
        sys.exit(1)

if __name__ == "__main__":
    main()