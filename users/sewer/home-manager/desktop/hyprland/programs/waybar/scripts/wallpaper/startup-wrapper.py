#!/usr/bin/env python3

"""
Startup wrapper for wallpaper scripts
Waits for hyprpaper to be ready before setting wallpaper
"""

import subprocess
import time
import sys
from pathlib import Path

# Setup library path
sys.path.insert(0, str(Path(__file__).parent))
from lib.path_setup import setup_lib_path
setup_lib_path()

# Now import from organized modules
from lib.config import WallpaperConfig
from lib.core.notifications import notify_error, notify_wallpaper_change, notify_info
from lib.services.wallpaper_manager import WallpaperManager
from lib.hyprland.lock_manager import hyprpaper_lock, HyprpaperLockError

def wait_for_hyprpaper(timeout=5, poll_interval=0.1):
    """Wait for hyprpaper to be ready
    
    Args:
        timeout: Maximum time to wait in seconds
        poll_interval: Time between checks in seconds
    
    Returns:
        bool: True if hyprpaper is ready, False if timeout
    """
    start_time = time.time()
    
    while time.time() - start_time < timeout:
        try:
            # Check if hyprpaper is responding
            subprocess.run(
                ['hyprctl', 'hyprpaper', 'listactive'], 
                check=True, 
                capture_output=True, 
                text=True,
                timeout=5
            )
            # If command succeeds, hyprpaper is ready
            return True
                
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
            # hyprpaper not ready yet, wait and retry
            time.sleep(poll_interval)
    
    return False


def main():
    """Main function to wait for hyprpaper and run wallpaper scripts"""
    # Check for --no-lock argument
    skip_lock = '--no-lock' in sys.argv
    
    def run_wallpaper_restoration():
        try:
            # Wait for hyprpaper to be ready
            if not wait_for_hyprpaper():
                notify_error("Startup timeout", "hyprpaper not ready after waiting")
                sys.exit(1)
            
            # Short delay to ensure hyprpaper is fully initialized
            # Needed for nixOS rebuild.
            notify_info("Restoring wallpapers...")
            time.sleep(0.75) # TERRIBLE HACK.

            # Restore saved wallpapers for each monitor
            try:
                config = WallpaperConfig()
                manager = WallpaperManager(config)
                
                # Clean up any missing wallpapers from state file
                manager.clean_missing_wallpapers()
                
                # Restore wallpapers for all monitors
                results = manager.restore_monitor_wallpapers()
                
                # Check results and notify
                successful_monitors = [name for name, result in results.items() if result.success]
                failed_monitors = [name for name, result in results.items() if not result.success]
                
                if successful_monitors:
                    monitor_list = ", ".join(successful_monitors)
                    notify_wallpaper_change(f"Restored wallpapers\nMonitors: {monitor_list}")
                
                if failed_monitors:
                    monitor_list = ", ".join(failed_monitors)
                    notify_error("Some wallpapers failed", f"Failed monitors: {monitor_list}")
                    
            except Exception as e:
                notify_error("Wallpaper startup failed", f"Unexpected error: {str(e)}")
            
            sys.exit(0)
            
        except Exception as e:
            notify_error("Startup wrapper error", f"Unexpected error: {str(e)}")
            sys.exit(1)
    
    if skip_lock:
        # Run without lock for manual calls
        run_wallpaper_restoration()
    else:
        # Prevent concurrent startup wrapper execution using file locking
        with hyprpaper_lock(silent_exit=True):
            run_wallpaper_restoration()


if __name__ == "__main__":
    main()