#!/usr/bin/env python3

"""
Cleanup wallpaper collection - remove files not in collection
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
    """Main function to cleanup untracked wallpapers"""
    try:
        config = WallpaperConfig()
        sync_service = CollectionSyncService(config)
        
        # First check what would be deleted
        untracked = sync_service.collection_manager.get_untracked_wallpapers()
        
        if not untracked:
            notify_success("Collection clean", "No untracked wallpapers found")
            sys.exit(0)
        
        # Show warning with count
        notify_info(f"Will remove {len(untracked)} untracked wallpapers")
        
        # Perform cleanup
        deleted = sync_service.cleanup_orphaned_files()
        notify_success("Cleanup complete", f"Removed {len(deleted)} files")
            
    except Exception as e:
        notify_error("Cleanup error", str(e))
        sys.exit(1)

if __name__ == "__main__":
    main()