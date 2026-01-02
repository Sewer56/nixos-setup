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
from lib.core.notifications import (
    notify_error,
    notify_wallpaper_change,
    notify_info,
    notify_success,
)
from lib.services.wallpaper_manager import WallpaperManager
from lib.hyprland.lock_manager import hyprpaper_lock, HyprpaperLockError
from lib.hyprland.screen_utils import get_monitor_info


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
            # Check if hyprpaper process is running
            # Note: In hyprpaper 0.8.0, 'listactive' was removed
            result = subprocess.run(
                ["pgrep", "-x", "hyprpaper"], capture_output=True, timeout=5
            )
            # If pgrep finds the process (exit code 0), hyprpaper is running
            if result.returncode == 0:
                return True

        except subprocess.TimeoutExpired:
            pass

        # hyprpaper not ready yet, wait and retry
        time.sleep(poll_interval)

    return False


def main():
    """Main function to wait for hyprpaper and run wallpaper scripts"""
    # Check for --no-lock argument
    skip_lock = "--no-lock" in sys.argv

    def run_wallpaper_restoration():
        try:
            # Wait for hyprpaper to be ready
            if not wait_for_hyprpaper():
                notify_error("Hyprpaper not ready", "Timed out waiting for hyprpaper")
                sys.exit(1)

            time.sleep(2) # TERRIBLE HACK. But hyprpaper removed listactive, so I have to.
            notify_info("Restoring wallpapers...")

            # Restore saved wallpapers for each monitor
            try:
                config = WallpaperConfig()
                manager = WallpaperManager(config)

                # Clean up any missing wallpapers from state file
                manager.clean_missing_wallpapers()

                # Restore wallpapers for all monitors
                results = manager.restore_monitor_wallpapers()

                # Get monitor info for display names
                monitors = get_monitor_info()
                monitor_display_map = {
                    monitor.name: monitor.display_name for monitor in monitors
                }

                # Check results and notify
                successful_monitors = [
                    monitor_display_map.get(name, name)
                    for name, result in results.items()
                    if result.success
                ]
                failed_monitors = [
                    monitor_display_map.get(name, name)
                    for name, result in results.items()
                    if not result.success
                ]

                if successful_monitors:
                    if len(successful_monitors) == 1:
                        notify_success(
                            f"Restored wallpaper for {successful_monitors[0]}"
                        )
                    else:
                        monitor_list = ", ".join(successful_monitors)
                        notify_success(
                            f"Restored wallpapers", f"Monitors: {monitor_list}"
                        )

                if failed_monitors:
                    if len(failed_monitors) == 1:
                        notify_error(
                            "Wallpaper restore failed", f"Monitor: {failed_monitors[0]}"
                        )
                    else:
                        monitor_list = ", ".join(failed_monitors)
                        notify_error(
                            "Some wallpapers failed", f"Failed monitors: {monitor_list}"
                        )

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
