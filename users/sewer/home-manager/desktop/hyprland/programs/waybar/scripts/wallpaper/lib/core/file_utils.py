#!/usr/bin/env python3

"""
File utility functions for wallpaper management
"""

from pathlib import Path
from typing import Union


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