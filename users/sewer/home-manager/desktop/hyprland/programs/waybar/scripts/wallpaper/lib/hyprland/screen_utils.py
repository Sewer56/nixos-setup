#!/usr/bin/env python3

"""
Multi-monitor utilities for Hyprland
"""

import json
import subprocess
from dataclasses import dataclass
from typing import List, Optional, Tuple


@dataclass
class MonitorInfo:
    """Information about a connected monitor"""
    name: str          # "DP-1", "HDMI-A-1" 
    width: int         # 1920
    height: int        # 1080
    scale: float       # 1.0
    is_primary: bool   # True for first monitor
    
    @property
    def resolution(self) -> str:
        """Get resolution as string (e.g., "1920x1080")"""
        return f"{self.width}x{self.height}"
    
    @property
    def pixel_count(self) -> int:
        """Get total pixel count for comparison"""
        return self.width * self.height


def get_monitor_info() -> List[MonitorInfo]:
    """Get information for all connected monitors
    
    Returns:
        List of MonitorInfo objects for all connected monitors
        Falls back to single 1920x1080 monitor if unable to detect
    """
    try:
        result = subprocess.run(
            ['hyprctl', 'monitors', '-j'],
            capture_output=True,
            text=True,
            check=True
        )
        
        monitors_data = json.loads(result.stdout)
        monitors = []
        
        for i, monitor_data in enumerate(monitors_data):
            monitor = MonitorInfo(
                name=monitor_data.get('name', f'UNKNOWN-{i}'),
                width=monitor_data.get('width', 1920),
                height=monitor_data.get('height', 1080),
                scale=monitor_data.get('scale', 1.0),
                is_primary=(i == 0)  # First monitor is primary
            )
            monitors.append(monitor)
        
        return monitors
        
    except (subprocess.CalledProcessError, json.JSONDecodeError, KeyError):
        # Fallback to single monitor
        return [MonitorInfo(
            name="FALLBACK-0",
            width=1920,
            height=1080,
            scale=1.0,
            is_primary=True
        )]


def get_primary_monitor() -> MonitorInfo:
    """Get the primary (first) monitor
    
    Returns:
        MonitorInfo for the primary monitor
    """
    monitors = get_monitor_info()
    return monitors[0]  # First monitor is always primary


def get_search_resolution() -> str:
    """Get the optimal resolution for wallpaper searches
    
    Uses the highest resolution among all monitors to ensure
    downloaded wallpapers work well on all displays.
    
    Returns:
        Resolution string in format "WIDTHxHEIGHT" (e.g., "2560x1440")
    """
    monitors = get_monitor_info()
    
    highest_monitor = max(monitors, key=lambda m: m.pixel_count)
    return highest_monitor.resolution