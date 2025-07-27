#!/usr/bin/env python3

"""
Set a random wallpaper from available collection
"""

import fcntl
import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.wallpaper import WallpaperManager
from lib.notifications import notify_error, notify_wallpaper_change

def main():
    """Main function to set random wallpaper"""
    # Prevent concurrent execution using file locking
    lockfile_path = "/tmp/wallpaper-random.lock"
    
    try:
        with open(lockfile_path, 'w') as lockfile:
            # Try to acquire exclusive lock (non-blocking)
            # Errors if lock cannot be acquired
            fcntl.flock(lockfile.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            
            # Lock acquired - proceed with wallpaper change
            manager = WallpaperManager()
            result = manager.set_random_wallpaper()
            
            if result.success:
                notify_wallpaper_change(result.wallpaper_name)
                sys.exit(0)
            else:
                notify_error("Failed to set random wallpaper", result.error_message)
                sys.exit(1)
            
            # Lock automatically released when file closes
            
    except BlockingIOError:
        # Another instance is running - exit silently
        sys.exit(0)
    except Exception as e:
        notify_error("Script error", f"Unexpected error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()