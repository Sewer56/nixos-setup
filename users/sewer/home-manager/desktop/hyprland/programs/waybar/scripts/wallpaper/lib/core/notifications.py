#!/usr/bin/env python3

"""
Desktop notification utilities for wallpaper scripts
"""

import subprocess
from typing import Optional


def notify_success(message: str, details: Optional[str] = None) -> None:
    """Send a success notification
    
    Args:
        message: Main notification message
        details: Optional additional details
    """
    full_message = f"{message}\n{details}" if details else message
    try:
        subprocess.run([
            'notify-send',
            'Wallpaper Success',
            full_message,
            '-i', 'dialog-information',
            '-t', '3000',
            '-u', 'low'
        ], check=True, capture_output=True)
    except subprocess.CalledProcessError:
        pass


def notify_error(message: str, details: Optional[str] = None) -> None:
    """Send an error notification
    
    Args:
        message: Main error message
        details: Optional error details
    """
    full_message = f"{message}\n{details}" if details else message
    try:
        subprocess.run([
            'notify-send',
            'Wallpaper Error',
            full_message,
            '-i', 'dialog-error',
            '-t', '5000',
            '-u', 'critical'
        ], check=True, capture_output=True)
    except subprocess.CalledProcessError:
        pass


def notify_progress(message: str, current: int, total: int) -> None:
    """Send a progress notification
    
    Args:
        message: Base progress message
        current: Current progress count
        total: Total items
    """
    progress_message = f"{message}\nProgress: {current}/{total}"
    try:
        subprocess.run([
            'notify-send',
            'Wallpaper Progress',
            progress_message,
            '-i', 'dialog-information',
            '-t', '2000',
            '-u', 'low'
        ], check=True, capture_output=True)
    except subprocess.CalledProcessError:
        pass


def notify_info(message: str) -> None:
    """Send an info notification
    
    Args:
        message: Information message
    """
    try:
        subprocess.run([
            'notify-send',
            'Wallpaper Info',
            message,
            '-i', 'dialog-information',
            '-t', '3000',
            '-u', 'low'
        ], check=True, capture_output=True)
    except subprocess.CalledProcessError:
        pass


def notify_wallpaper_change(wallpaper_name: str) -> None:
    """Send wallpaper change notification
    
    Args:
        wallpaper_name: Name of the new wallpaper
    """
    try:
        subprocess.run([
            'notify-send',
            'Wallpaper Changed',
            f'Set to: {wallpaper_name}',
            '-i', 'preferences-desktop-wallpaper',
            '-t', '3000',
            '-u', 'low'
        ], check=True, capture_output=True)
    except subprocess.CalledProcessError:
        pass