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
    name: str          # Port name: "DP-1", "HDMI-A-1" 
    description: str   # Display description: "Samsung Electric Company Odyssey G95NC HNTXC00136"
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
    
    @property
    def composite_key(self) -> str:
        """Get composite key for state storage
        
        Returns:
            Composite key in format "description|port_name"
        """
        return f"{self.description}|{self.name}"
    
    @property
    def display_name(self) -> str:
        """Get user-friendly display name for notifications
        
        Returns:
            Display name in format "Monitor Description (Port)" or "Port" if description is generic
        """
        # Check if description is generic/fallback
        if (self.description.startswith("Unknown Display") or 
            self.description == "Fallback Display" or
            not self.description.strip()):
            return self.name
        
        # Use raw description with port name
        return f"{self.description} ({self.name})"


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
                description=monitor_data.get('description', f'Unknown Display {i}'),
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
            description="Fallback Display",
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


def parse_resolution_string(resolution_str: str) -> Tuple[int, int]:
    """Parse resolution string into width and height integers
    
    Args:
        resolution_str: Resolution string in format "WIDTHxHEIGHT" (e.g., "1920x1080")
        
    Returns:
        Tuple of (width, height) as integers, (0, 0) if parsing fails
    """
    try:
        width_str, height_str = resolution_str.split('x')
        return int(width_str), int(height_str)
    except (ValueError, AttributeError):
        return 0, 0


def meets_resolution_requirement(wallpaper_resolution: str, min_resolution: str) -> bool:
    """Check if wallpaper meets minimum resolution requirement (both width AND height)
    
    This matches how Wallhaven's 'atleast' parameter works: both dimensions
    must be greater than or equal to the minimum requirement.
    
    Args:
        wallpaper_resolution: Wallpaper resolution string (e.g., "3840x2160")
        min_resolution: Minimum required resolution string (e.g., "1920x1080")
        
    Returns:
        True if wallpaper_width >= min_width AND wallpaper_height >= min_height
    """
    if not wallpaper_resolution or not min_resolution:
        return True  # Don't filter if either resolution is missing
    
    wall_width, wall_height = parse_resolution_string(wallpaper_resolution)
    min_width, min_height = parse_resolution_string(min_resolution)
    
    # Both parsing operations must succeed
    if (wall_width == 0 or wall_height == 0 or 
        min_width == 0 or min_height == 0):
        return True  # Don't filter if parsing failed
    
    # Both dimensions must meet the requirement
    return wall_width >= min_width and wall_height >= min_height