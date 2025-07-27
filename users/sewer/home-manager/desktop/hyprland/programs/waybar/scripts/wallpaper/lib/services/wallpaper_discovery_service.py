#!/usr/bin/env python3

"""
Wallpaper discovery service for finding and listing wallpapers
"""

import random
from pathlib import Path
from typing import List, Optional

from ..config import WallpaperConfig
from ..constants import SUPPORTED_EXTENSIONS


class WallpaperDiscoveryService:
    """Service for discovering and listing wallpapers from various sources"""
    
    def __init__(self, config: WallpaperConfig):
        """Initialize wallpaper discovery service
        
        Args:
            config: WallpaperConfig instance
        """
        self.config = config
        self.wallpaper_dir = config.base_dir
        self.saved_dir = config.saved_dir
        self.temp_dir = config.temp_dir
    
    def get_all_wallpapers(self) -> List[Path]:
        """Get list of all available wallpaper files
        
        Returns:
            List of Path objects for wallpaper files
        """
        wallpapers = []
        
        # Search in all directories including root
        search_dirs = [self.wallpaper_dir, self.saved_dir, self.temp_dir]
        
        for search_dir in search_dirs:
            if search_dir.exists():
                for ext in SUPPORTED_EXTENSIONS:
                    # Use glob instead of rglob to avoid duplicates from subdirectories
                    wallpapers.extend(search_dir.glob(f"*{ext}"))
        
        return sorted(list(set(wallpapers)))  # Remove duplicates and sort
    
    def get_favorite_wallpapers(self) -> List[Path]:
        """Get list of wallpapers from favorites sources only (saved)
        
        Returns:
            List of Path objects for favorite wallpaper files
        """
        wallpapers = []
        
        # Only search in saved directory (wallhaven sync removed)
        search_dirs = [self.saved_dir]
        
        for search_dir in search_dirs:
            if search_dir.exists():
                for ext in SUPPORTED_EXTENSIONS:
                    wallpapers.extend(search_dir.glob(f"*{ext}"))
        
        return sorted(wallpapers)
    
    def get_random_wallpaper(self, exclude_current: Optional[Path] = None) -> Optional[Path]:
        """Get a random wallpaper from favorites collection, optionally excluding a specific wallpaper
        
        Args:
            exclude_current: Path to wallpaper to exclude from selection
            
        Returns:
            Path to random wallpaper file, or None if no wallpapers found or only excluded wallpaper available
        """
        wallpapers = self.get_favorite_wallpapers()
        if not wallpapers:
            return None
        
        # Filter out excluded wallpaper from choices
        if exclude_current:
            available_wallpapers = [w for w in wallpapers if w != exclude_current]
            # If no different wallpapers available, return None
            if not available_wallpapers:
                return None
            wallpapers = available_wallpapers
        
        return random.choice(wallpapers)