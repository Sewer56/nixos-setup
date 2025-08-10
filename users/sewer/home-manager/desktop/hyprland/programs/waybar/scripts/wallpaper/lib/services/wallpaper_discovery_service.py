#!/usr/bin/env python3

"""
Wallpaper discovery service for finding and listing wallpapers
"""

import random
from pathlib import Path
from typing import Callable, List, Optional

from ..config import WallpaperConfig
from ..constants import SUPPORTED_EXTENSIONS
from ..core.collection_manager import CollectionManager


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
        self.current_random_dir = config.current_random_dir
        self.next_random_dir = config.next_random_dir
        self.collection_manager = CollectionManager(config)
    
    def get_all_wallpapers(self) -> List[Path]:
        """Get list of all available wallpaper files
        
        Returns:
            List of Path objects for wallpaper files
        """
        wallpapers = []
        
        # Search in all directories including root
        search_dirs = [self.wallpaper_dir, self.saved_dir, self.current_random_dir, self.next_random_dir]
        
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
    
    def get_random_wallpaper(self, filter_func: Optional[Callable[[Path], bool]] = None) -> Optional[Path]:
        """Get a random wallpaper from favorites collection, optionally filtered by a predicate function
        
        Args:
            filter_func: Optional predicate function that returns True for wallpapers that should be included
            
        Returns:
            Path to random wallpaper file, or None if no wallpapers found or no wallpapers pass filter
        """
        wallpapers = self.get_favorite_wallpapers()
        if not wallpapers:
            return None
        
        # Apply filter if provided
        if filter_func:
            available_wallpapers = [w for w in wallpapers if filter_func(w)]
            # If no wallpapers pass filter, return None
            if not available_wallpapers:
                return None
            wallpapers = available_wallpapers
        
        return random.choice(wallpapers)
    
