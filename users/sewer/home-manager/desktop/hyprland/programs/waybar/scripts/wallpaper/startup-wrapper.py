#!/usr/bin/env python3

"""
Startup wrapper for wallpaper scripts
Waits for hyprpaper to be ready before setting wallpaper
"""

import subprocess
import time
import sys
from pathlib import Path

# Add script directory to Python path for lib module imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))
sys.path.insert(0, str(script_dir / "lib"))

from lib.notifications import notify_error, notify_wallpaper_change
from lib.wallpaper import WallpaperManager

def wait_for_hyprpaper(timeout=30, poll_interval=0.1):
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
                ['hyprctl', 'hyprpaper', 'listloaded'], 
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
    try:
        # Wait for hyprpaper to be ready
        if not wait_for_hyprpaper():
            notify_error("Startup timeout", "hyprpaper not ready after 30 seconds")
            sys.exit(1)
        
        # Set random wallpaper directly
        try:
            manager = WallpaperManager()
            result = manager.set_random_wallpaper()
            
            if result.success:
                notify_wallpaper_change(result.wallpaper_name)
            else:
                notify_error("Failed to set random wallpaper", result.error_message)
        except Exception as e:
            notify_error("Wallpaper startup failed", f"Unexpected error: {str(e)}")
        
        sys.exit(0)
        
    except Exception as e:
        notify_error("Startup wrapper error", f"Unexpected error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()