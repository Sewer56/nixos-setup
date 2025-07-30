#!/usr/bin/env python3

"""
Startup sync - wait for internet then restore missing wallpapers on system startup
"""

import subprocess
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from lib.path_setup import setup_lib_path
setup_lib_path()

from lib.config import WallpaperConfig
from lib.services.collection_sync_service import CollectionSyncService

def wait_for_internet(max_wait_seconds=60, check_interval=5):
    """Wait for internet connectivity with timeout"""
    start_time = time.time()
    
    while time.time() - start_time < max_wait_seconds:
        try:
            # Try to ping a reliable server
            result = subprocess.run(['ping', '-c', '1', '-W', '3', '1.1.1.1'], 
                                  capture_output=True, timeout=5)
            if result.returncode == 0:
                return True
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass
        
        time.sleep(check_interval)
    
    return False

def main():
    """Wait for internet then sync missing wallpapers silently"""
    try:
        # Wait for internet connectivity
        if not wait_for_internet():
            # No internet after timeout, exit silently
            sys.exit(0)
        
        # Call sync function directly
        config = WallpaperConfig()
        sync_service = CollectionSyncService(config)
        sync_service.sync_missing_wallpapers()
        
    except Exception:
        # Fail silently on startup
        pass

if __name__ == "__main__":
    main()