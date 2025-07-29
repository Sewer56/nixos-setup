#!/usr/bin/env python3

"""
Update wallpaper collection - add untracked wallpapers from saved directory
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
    """Main function to update collection from disk"""
    try:
        notify_info("Updating collection - Scanning for new wallpapers...")
        
        config = WallpaperConfig()
        sync_service = CollectionSyncService(config)
        stats = sync_service.update_collection_from_disk()
        
        added_count = stats.get('added', 0)
        if added_count > 0:
            notify_success("Collection updated", f"Added {added_count} wallpapers")
        else:
            notify_success("No new wallpapers", "Collection is up to date")
            
    except Exception as e:
        notify_error("Update error", str(e))
        sys.exit(1)

if __name__ == "__main__":
    main()