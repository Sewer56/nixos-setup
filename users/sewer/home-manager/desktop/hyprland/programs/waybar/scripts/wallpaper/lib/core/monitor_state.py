#!/usr/bin/env python3

"""
Monitor wallpaper state persistence for multi-monitor setups
"""

import json
from datetime import datetime
from pathlib import Path
from typing import Dict, Optional

from ..config import WallpaperConfig
from ..hyprland.screen_utils import MonitorInfo


class MonitorStateManager:
    """Manages persistent state for monitor wallpaper assignments"""
    
    def __init__(self, config: Optional[WallpaperConfig] = None):
        """Initialize state manager
        
        Args:
            config: WallpaperConfig instance. If None, uses default configuration
        """
        if config is None:
            config = WallpaperConfig()
        self.config = config
        self.state_file = config.state_file
        
        # Ensure base directory exists
        config.base_dir.mkdir(parents=True, exist_ok=True)
    
    def _load_state_file(self) -> Dict:
        """Load state file or return empty state structure"""
        if not self.state_file.exists():
            return {
                "version": "1.0",
                "monitors": {}
            }
        
        try:
            with open(self.state_file, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            # Return empty state if file is corrupted
            return {
                "version": "1.0", 
                "monitors": {}
            }
    
    def _save_state_file(self, state: Dict) -> None:
        """Save state to file"""
        try:
            with open(self.state_file, 'w') as f:
                json.dump(state, f, indent=2)
        except OSError:
            # Silently fail if unable to write (permissions, disk space, etc.)
            pass
    
    def save_monitor_wallpaper(self, monitor_name: str, wallpaper_path: Path, resolution: str) -> None:
        """Save wallpaper assignment for a monitor
        
        Args:
            monitor_name: Monitor name (e.g., "DP-1")
            wallpaper_path: Path to wallpaper file
            resolution: Monitor resolution (e.g., "1920x1080")
        """
        state = self._load_state_file()
        
        state["monitors"][monitor_name] = {
            "wallpaper_path": str(wallpaper_path),
            "resolution": resolution,
            "last_updated": datetime.now().isoformat()
        }
        
        self._save_state_file(state)
    
    def get_monitor_wallpaper(self, monitor_name: str) -> Optional[Path]:
        """Get saved wallpaper for a monitor
        
        Args:
            monitor_name: Monitor name to look up
            
        Returns:
            Path to wallpaper file, or None if not found or file doesn't exist
        """
        state = self._load_state_file()
        
        monitor_data = state.get("monitors", {}).get(monitor_name)
        if not monitor_data:
            return None
        
        wallpaper_path = Path(monitor_data["wallpaper_path"])
        
        # Only return if file still exists
        if wallpaper_path.exists():
            return wallpaper_path
        
        return None
    
    def get_all_monitor_wallpapers(self) -> Dict[str, Path]:
        """Get all saved monitor wallpaper assignments
        
        Returns:
            Dictionary mapping monitor names to wallpaper paths
            Only includes monitors where wallpaper files still exist
        """
        state = self._load_state_file()
        wallpapers = {}
        
        for monitor_name, monitor_data in state.get("monitors", {}).items():
            wallpaper_path = Path(monitor_data["wallpaper_path"])
            if wallpaper_path.exists():
                wallpapers[monitor_name] = wallpaper_path
        
        return wallpapers
    
    def remove_monitor_wallpaper(self, monitor_name: str) -> None:
        """Remove wallpaper assignment for a monitor
        
        Args:
            monitor_name: Monitor name to remove
        """
        state = self._load_state_file()
        
        if monitor_name in state.get("monitors", {}):
            del state["monitors"][monitor_name]
            self._save_state_file(state)
    
    def clean_missing_wallpapers(self) -> None:
        """Remove entries for wallpapers that no longer exist"""
        state = self._load_state_file()
        monitors_to_remove = []
        
        for monitor_name, monitor_data in state.get("monitors", {}).items():
            wallpaper_path = Path(monitor_data["wallpaper_path"])
            if not wallpaper_path.exists():
                monitors_to_remove.append(monitor_name)
        
        for monitor_name in monitors_to_remove:
            del state["monitors"][monitor_name]
        
        if monitors_to_remove:
            self._save_state_file(state)
    
    def get_monitors_without_wallpaper(self, connected_monitors: list[MonitorInfo]) -> list[MonitorInfo]:
        """Get list of connected monitors that don't have saved wallpapers
        
        Args:
            connected_monitors: List of currently connected monitors
            
        Returns:
            List of MonitorInfo objects that need wallpaper assignment
        """
        saved_wallpapers = self.get_all_monitor_wallpapers()
        
        monitors_without_wallpaper = []
        for monitor in connected_monitors:
            if monitor.name not in saved_wallpapers:
                monitors_without_wallpaper.append(monitor)
        
        return monitors_without_wallpaper