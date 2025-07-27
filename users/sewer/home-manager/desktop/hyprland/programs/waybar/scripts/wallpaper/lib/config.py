#!/usr/bin/env python3

"""Configuration management for wallpaper scripts"""

from pathlib import Path
from typing import Dict, Optional
from .constants import DEFAULT_WALLPAPER_DIR, DEFAULT_SUBDIRS

class WallpaperConfig:
    """Manages configuration for wallpaper operations"""
    
    def __init__(self, 
                 base_dir: Optional[str] = None,
                 subdirs: Optional[Dict[str, str]] = None,
                 state_file: Optional[str] = None):
        """Initialize configuration
        
        Args:
            base_dir: Base wallpaper directory (defaults to ~/Pictures/wallpapers)
            subdirs: Custom subdirectory names. Merges with defaults, overriding matching keys.
                    Example: {'saved': 'favorites', 'temp': 'downloads', 'archive': 'old'}
                    Results in directories: favorites/, downloads/, old/
            state_file: Monitor state file name (defaults to monitor_state.json)
        """
        self.base_dir = Path(base_dir).expanduser() if base_dir else Path(DEFAULT_WALLPAPER_DIR).expanduser()
        self.subdirs = {**DEFAULT_SUBDIRS, **(subdirs or {})}
        self.state_file_name = state_file or "monitor_state.json"
        
        # Ensure all directories exist
        self._ensure_directories_exist()
    
    def get_path(self, subdir: str) -> Path:
        """Get full path for a subdirectory"""
        return self.base_dir / self.subdirs.get(subdir, subdir)
    
    @property
    def saved_dir(self) -> Path:
        return self.get_path('saved')
    
    @property
    def temp_dir(self) -> Path:
        return self.get_path('temp')
    
    @property
    def state_file(self) -> Path:
        return self.base_dir / self.state_file_name
    
    def _ensure_directories_exist(self) -> None:
        """Ensure all configured directories exist"""
        # Create base directory
        self.base_dir.mkdir(parents=True, exist_ok=True)
        
        # Create all subdirectories
        for subdir_name in self.subdirs.values():
            (self.base_dir / subdir_name).mkdir(parents=True, exist_ok=True)