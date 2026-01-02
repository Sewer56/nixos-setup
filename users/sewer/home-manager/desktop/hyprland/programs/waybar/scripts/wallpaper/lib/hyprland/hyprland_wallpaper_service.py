#!/usr/bin/env python3

"""
Hyprland-specific wallpaper operation service for setting and retrieving wallpapers
"""

import subprocess
from pathlib import Path
from typing import Dict, List, Optional

from ..core.results import WallpaperResult
from ..config import WallpaperConfig
from ..core.monitor_state import MonitorStateManager
from .screen_utils import MonitorInfo, get_monitor_info, get_primary_monitor


class HyprlandWallpaperService:
    """Hyprland-specific service for wallpaper setting and retrieval operations"""

    def __init__(self, config: WallpaperConfig):
        """Initialize Hyprland wallpaper service

        Args:
            config: WallpaperConfig instance
        """
        self.config = config
        self.state_manager = MonitorStateManager(config)

    def get_current_wallpapers(self) -> Dict[str, Optional[Path]]:
        """Get currently active wallpapers for each monitor

        Returns:
            Dictionary mapping monitor port names (DP-1, etc.) to wallpaper paths
        """
        wallpapers = {}

        try:
            result = subprocess.run(
                ["hyprctl", "hyprpaper", "listactive"],
                check=True,
                capture_output=True,
                text=True,
            )
            output = result.stdout.strip()

            if output and output != "no wallpapers loaded":
                # Parse multiple lines in format: "monitor = wallpaper_path"
                lines = output.split("\n")
                for line in lines:
                    if " = " in line:
                        monitor_name, wallpaper_path = line.split(" = ", 1)
                        monitor_name = monitor_name.strip()
                        wallpaper_path = wallpaper_path.strip()
                        wallpapers[monitor_name] = Path(wallpaper_path)

        except subprocess.CalledProcessError:
            pass

        return wallpapers

    def get_current_wallpaper(
        self, monitor_name: Optional[str] = None
    ) -> Optional[Path]:
        """Get currently active wallpaper for a specific monitor or primary monitor

        Args:
            monitor_name: Monitor port name (DP-1, etc.) to get wallpaper for. If None, uses primary monitor

        Returns:
            Path to current wallpaper file, or None if no wallpaper is active
        """
        current_wallpapers = self.get_current_wallpapers()

        if monitor_name:
            return current_wallpapers.get(monitor_name)
        else:
            # Return primary monitor's wallpaper, or first available
            primary_monitor = get_primary_monitor()
            if primary_monitor.name in current_wallpapers:
                return current_wallpapers[primary_monitor.name]

            # Fallback: return first available wallpaper
            if current_wallpapers:
                return list(current_wallpapers.values())[0]

            return None

    def _execute_wallpaper_command(
        self, wallpaper_path: Path, monitor_spec: str
    ) -> WallpaperResult:
        """Execute hyprctl wallpaper command with given monitor specification

        Args:
            wallpaper_path: Path to wallpaper file
            monitor_spec: Monitor specification for hyprctl (port name like "DP-1" or "" for all)

        Returns:
            WallpaperResult with success status and details
        """
        if not wallpaper_path.exists():
            return WallpaperResult(
                success=False,
                wallpaper_path=wallpaper_path,
                error_message=f"Wallpaper file not found: {wallpaper_path}",
            )

        try:
            # Use wallpaper command with monitor specification
            # Syntax: hyprctl hyprpaper wallpaper "monitor_spec,wallpaper_path"
            subprocess.run(
                [
                    "hyprctl",
                    "hyprpaper",
                    "wallpaper",
                    f"{monitor_spec},{wallpaper_path}",
                ],
                check=True,
                capture_output=True,
            )

            return WallpaperResult(success=True, wallpaper_path=wallpaper_path)

        except subprocess.CalledProcessError as e:
            return WallpaperResult(
                success=False,
                wallpaper_path=wallpaper_path,
                error_message=f"hyprctl error: {e}",
            )

    def set_wallpaper_for_monitor(
        self, wallpaper_path: Path, monitor_name: str, save_state: bool = True
    ) -> WallpaperResult:
        """Set wallpaper for a specific monitor

        Args:
            wallpaper_path: Path to wallpaper file
            monitor_name: Monitor port name (DP-1, etc.) to set wallpaper on
            save_state: Whether to save the state to monitor state manager

        Returns:
            WallpaperResult with success status and details
        """
        result = self._execute_wallpaper_command(wallpaper_path, monitor_name)

        if result.success and save_state:
            # Get monitor info for the specific monitor
            monitors = get_monitor_info()
            target_monitor = next((m for m in monitors if m.name == monitor_name), None)
            if target_monitor:
                self._save_wallpaper_state(wallpaper_path, [target_monitor])

        return result

    def set_wallpaper_all_monitors(
        self, wallpaper_path: Path, save_state: bool = True
    ) -> WallpaperResult:
        """Set same wallpaper on all connected monitors using explicit port names

        Args:
            wallpaper_path: Path to wallpaper file
            save_state: Whether to save the state to monitor state manager (using display descriptions)

        Returns:
            WallpaperResult with success status and details
        """
        # Get all connected monitors
        monitors = get_monitor_info()

        if not monitors:
            return WallpaperResult(
                success=False,
                wallpaper_path=wallpaper_path,
                error_message="No monitors detected",
            )

        # Set wallpaper on each monitor individually
        results = []
        failed_monitors = []

        for monitor in monitors:
            # Use save_state=False to avoid individual saves, we'll save all at once at the end
            result = self.set_wallpaper_for_monitor(
                wallpaper_path, monitor.name, save_state=False
            )
            results.append(result)

            if not result.success:
                failed_monitors.append(monitor.display_name)

        # Check if any monitors succeeded
        successful_results = [r for r in results if r.success]

        if successful_results:
            # At least some monitors succeeded
            if save_state:
                # Save state for all monitors (both successful and failed attempts)
                # This maintains the existing behavior where state is saved optimistically
                self._save_wallpaper_state(wallpaper_path, monitors)

            if failed_monitors:
                # Partial success
                return WallpaperResult(
                    success=True,
                    wallpaper_path=wallpaper_path,
                    error_message=f"Set wallpaper on {len(successful_results)}/{len(monitors)} monitors. Failed: {', '.join(failed_monitors)}",
                )
            else:
                # Complete success
                return WallpaperResult(success=True, wallpaper_path=wallpaper_path)
        else:
            # All monitors failed
            error_messages = [
                f"{monitors[i].display_name}: {results[i].error_message}"
                for i in range(len(monitors))
                if results[i].error_message
            ]
            combined_error = (
                "; ".join(error_messages) if error_messages else "All monitors failed"
            )

            return WallpaperResult(
                success=False,
                wallpaper_path=wallpaper_path,
                error_message=f"Failed to set wallpaper on all monitors. {combined_error}",
            )

    def restore_monitor_wallpapers(
        self, fallback_wallpaper_provider
    ) -> Dict[str, WallpaperResult]:
        """Restore saved wallpapers for all connected monitors using two-tier resolution

        Args:
            fallback_wallpaper_provider: Callable that returns a wallpaper Path for monitors without saved state

        Returns:
            Dictionary mapping monitor port names to WallpaperResult objects
        """
        results = {}
        monitors = get_monitor_info()

        for monitor in monitors:
            # Use new two-tier resolution system
            wallpaper_path = self.state_manager.find_monitor_wallpaper(
                monitor, monitors
            )

            if wallpaper_path:
                # Use without state saving to avoid redundant state saving during restoration
                results[monitor.name] = self.set_wallpaper_for_monitor(
                    wallpaper_path, monitor.name, save_state=False
                )
            else:
                # Assign fallback wallpaper to monitors without saved wallpaper
                fallback_wallpaper = fallback_wallpaper_provider()
                if fallback_wallpaper:
                    # For new assignments, use the regular method that saves state
                    results[monitor.name] = self.set_wallpaper_for_monitor(
                        fallback_wallpaper, monitor.name, save_state=True
                    )
                else:
                    results[monitor.name] = WallpaperResult(
                        success=False,
                        error_message=f"No wallpaper to assign to monitor {monitor.display_name}",
                    )

        return results

    def _save_wallpaper_state(
        self, wallpaper_path: Path, monitors: Optional[List[MonitorInfo]] = None
    ) -> None:
        """Save wallpaper state for specified monitors using composite key system

        Args:
            wallpaper_path: Path to wallpaper file
            monitors: List of MonitorInfo objects to save state for. If None, saves for all monitors
        """
        if monitors is None:
            monitors = get_monitor_info()

        # Save for all specified monitors using new simplified API
        for monitor in monitors:
            self.state_manager.save_monitor_wallpaper(monitor, wallpaper_path)
