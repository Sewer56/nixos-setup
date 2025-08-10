#!/usr/bin/env python3

"""
Monitor wallpaper state persistence for multi-monitor setups
"""

import json
from pathlib import Path
from typing import Dict, Optional, List

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
    
    def _get_monitor_key(self, monitor_description: str, port_name: str) -> str:
        """Generate composite key for monitor identification
        
        Args:
            monitor_description: Monitor description string
            port_name: Port name (e.g., "DP-1", "HDMI-A-1")
            
        Returns:
            Composite key in format "description|port_name"
        """
        return f"{monitor_description}|{port_name}"
    
    def _load_state_file(self) -> Dict:
        """Load state file or return empty state structure"""
        if not self.state_file.exists():
            return {
                "version": "2.0",
                "monitors": {}
            }
        
        try:
            with open(self.state_file, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            # Return empty state if file is corrupted
            return {
                "version": "2.0", 
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
    
    def save_monitor_wallpaper(self, monitor: MonitorInfo, wallpaper_path: Path) -> None:
        """Save wallpaper assignment for a monitor using composite key system
        
        Args:
            monitor: MonitorInfo object containing monitor details
            wallpaper_path: Path to wallpaper file
        """
        state = self._load_state_file()
        
        state["monitors"][monitor.composite_key] = {
            "wallpaper_path": str(wallpaper_path),
            "resolution": monitor.resolution,
            "description": monitor.description,
            "port": monitor.name
        }
        
        self._save_state_file(state)
    
    def find_monitor_wallpaper(self, monitor: MonitorInfo, connected_monitors: List[MonitorInfo]) -> Optional[Path]:
        """Find wallpaper for monitor using two-tier resolution system
        
        Args:
            monitor: MonitorInfo object to find wallpaper for
            connected_monitors: List of all currently connected monitors
            
        Returns:
            Path to wallpaper file, or None if not found or file doesn't exist
        """
        state = self._load_state_file()
        
        # Tier 1: Exact match with composite key
        if monitor.composite_key in state["monitors"]:
            path = Path(state["monitors"][monitor.composite_key]["wallpaper_path"])
            if path.exists():
                return path
        
        # Tier 2: Find by description (monitor may have moved ports)
        candidates = []
        for key, data in state["monitors"].items():
            if data.get("description") == monitor.description:
                candidates.append((key, data))
        
        if candidates:
            # Get ports currently in use by other monitors
            ports_in_use = {m.name for m in connected_monitors if m.description != monitor.description}
            
            # Prefer entries with ports not currently connected to other monitors
            for key, data in candidates:
                entry_port = data.get("port")
                if entry_port and (entry_port not in ports_in_use):
                    path = Path(data["wallpaper_path"])
                    if path.exists():
                        return path
            
            # Fallback to first available candidate
            for key, data in candidates:
                path = Path(data["wallpaper_path"])
                if path.exists():
                    return path
        
        return None
    
    
    def get_all_monitor_wallpapers(self) -> Dict[str, Path]:
        """Get all saved monitor wallpaper assignments
        
        Returns:
            Dictionary mapping composite keys to wallpaper paths
            Only includes monitors where wallpaper files still exist
        """
        state = self._load_state_file()
        wallpapers = {}
        
        for composite_key, monitor_data in state.get("monitors", {}).items():
            wallpaper_path = Path(monitor_data["wallpaper_path"])
            if wallpaper_path.exists():
                wallpapers[composite_key] = wallpaper_path
        
        return wallpapers
    
    def remove_monitor_wallpaper(self, monitor: MonitorInfo) -> None:
        """Remove wallpaper assignment for a monitor using composite key
        
        Args:
            monitor: MonitorInfo object containing monitor details
        """
        state = self._load_state_file()
        
        if monitor.composite_key in state.get("monitors", {}):
            del state["monitors"][monitor.composite_key]
            self._save_state_file(state)
    
    def clean_missing_wallpapers(self) -> None:
        """Remove entries for wallpapers that no longer exist"""
        state = self._load_state_file()
        keys_to_remove = []
        
        for composite_key, monitor_data in state.get("monitors", {}).items():
            wallpaper_path = Path(monitor_data["wallpaper_path"])
            if not wallpaper_path.exists():
                keys_to_remove.append(composite_key)
        
        for composite_key in keys_to_remove:
            del state["monitors"][composite_key]
        
        if keys_to_remove:
            self._save_state_file(state)
    
    def get_monitors_without_wallpaper(self, connected_monitors: list[MonitorInfo]) -> list[MonitorInfo]:
        """Get list of connected monitors that don't have saved wallpapers
        
        Args:
            connected_monitors: List of currently connected monitors
            
        Returns:
            List of MonitorInfo objects that need wallpaper assignment
        """
        monitors_without_wallpaper = []
        for monitor in connected_monitors:
            wallpaper_path = self.find_monitor_wallpaper(monitor, connected_monitors)
            if wallpaper_path is None:
                monitors_without_wallpaper.append(monitor)
        
        return monitors_without_wallpaper