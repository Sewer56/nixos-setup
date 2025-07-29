#!/usr/bin/env python3

"""
File utility functions for wallpaper management
"""

import subprocess
from pathlib import Path
from typing import Union, Optional


def clear_directory_contents(directory: Union[str, Path]) -> None:
    """Clear all files from a directory, keeping the directory itself
    
    Args:
        directory: Directory path to clear
    """
    directory = Path(directory)
    if directory.exists() and directory.is_dir():
        for file_path in directory.iterdir():
            if file_path.is_file():
                try:
                    file_path.unlink()
                except Exception:
                    # Silently ignore errors (file may be in use, permissions, etc.)
                    pass


def get_image_resolution(image_path: Union[str, Path]) -> Optional[str]:
    """Get resolution of an image file using jxlinfo for JXL files
    
    Args:
        image_path: Path to the image file
        
    Returns:
        Resolution string in format "WIDTHxHEIGHT" or None if unable to determine
    """
    image_path = Path(image_path)
    
    if not image_path.exists():
        return None
    
    try:
        # Use jxlinfo for JXL files
        if image_path.suffix.lower() == '.jxl':
            result = subprocess.run(['jxlinfo', str(image_path)], 
                                  capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                # Parse output like "JPEG XL image, 3840x2160, lossy, 8-bit RGB+Alpha"
                lines = result.stdout.strip().split('\n')
                if lines:
                    first_line = lines[0]
                    # Look for pattern like "3840x2160" in the first line
                    parts = first_line.split(', ')
                    for part in parts:
                        if 'x' in part and part.replace('x', '').replace(' ', '').isdigit():
                            # Found resolution part, extract just the resolution
                            resolution = part.strip()
                            # Validate it's actually a resolution (numbers with x)
                            try:
                                width, height = resolution.split('x')
                                int(width)
                                int(height)
                                return resolution
                            except (ValueError, IndexError):
                                continue
        
        # For other image formats, could add support for imagemagick identify, etc.
        # For now, return None for non-JXL files
        
    except (subprocess.TimeoutExpired, subprocess.CalledProcessError, FileNotFoundError):
        # jxlinfo not available or failed
        pass
    
    return None