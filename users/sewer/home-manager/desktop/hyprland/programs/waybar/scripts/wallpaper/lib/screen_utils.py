#!/usr/bin/env python3

"""
Screen resolution utilities for Hyprland
"""

import json
import subprocess
from typing import Optional, Tuple


def get_screen_resolution() -> str:
    """Get current screen resolution from Hyprland
    
    Returns:
        Resolution string in format "WIDTHxHEIGHT" (e.g., "1920x1080")
        Falls back to "1920x1080" if unable to detect
    """
    try:
        # Get monitor information from hyprctl
        result = subprocess.run(
            ['hyprctl', 'monitors', '-j'],
            capture_output=True,
            text=True,
            check=True
        )
        
        monitors = json.loads(result.stdout)
        
        if monitors and len(monitors) > 0:
            # Get primary (first) monitor resolution
            monitor = monitors[0]
            width = monitor.get('width', 1920)
            height = monitor.get('height', 1080)
            return f"{width}x{height}"
        
    except (subprocess.CalledProcessError, json.JSONDecodeError, KeyError):
        pass
    
    # Fallback resolution
    return "1920x1080"


def get_all_resolutions() -> list[str]:
    """Get resolutions of all connected monitors
    
    Returns:
        List of resolution strings for all monitors
    """
    resolutions = []
    
    try:
        result = subprocess.run(
            ['hyprctl', 'monitors', '-j'],
            capture_output=True,
            text=True,
            check=True
        )
        
        monitors = json.loads(result.stdout)
        
        for monitor in monitors:
            width = monitor.get('width', 1920)
            height = monitor.get('height', 1080)
            resolutions.append(f"{width}x{height}")
            
    except (subprocess.CalledProcessError, json.JSONDecodeError, KeyError):
        # Return fallback if unable to get monitor info
        resolutions.append("1920x1080")
    
    return resolutions


def parse_resolution(resolution_str: str) -> Optional[Tuple[int, int]]:
    """Parse resolution string into width and height
    
    Args:
        resolution_str: Resolution in format "WIDTHxHEIGHT"
        
    Returns:
        Tuple of (width, height) or None if invalid format
    """
    try:
        width, height = resolution_str.lower().split('x')
        return (int(width), int(height))
    except (ValueError, AttributeError):
        return None


def get_highest_resolution() -> str:
    """Get the highest resolution among all monitors
    
    Returns:
        Resolution string of the highest resolution monitor
    """
    resolutions = get_all_resolutions()
    
    highest_pixels = 0
    highest_res = "1920x1080"
    
    for res_str in resolutions:
        parsed = parse_resolution(res_str)
        if parsed:
            width, height = parsed
            pixels = width * height
            if pixels > highest_pixels:
                highest_pixels = pixels
                highest_res = res_str
    
    return highest_res