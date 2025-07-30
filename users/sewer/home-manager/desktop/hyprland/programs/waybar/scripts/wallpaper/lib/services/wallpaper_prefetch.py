#!/usr/bin/env python3

"""
Wallpaper prefetching utilities for fast wallpaper switching
"""

import shutil
import threading
from pathlib import Path
from typing import Optional, Dict, Any

from ..config import WallpaperConfig
from ..core.file_utils import clear_directory_contents
from ..wallhaven.downloader import WallpaperDownloader
from ..wallhaven.search import WallhavenSearch

class WallpaperPrefetch:
    """Handles wallpaper prefetching for fast switching"""
    
    def __init__(self, config: WallpaperConfig):
        """Initialize prefetch service
        
        Args:
            config: WallpaperConfig instance
        """
        self.config = config
    
    def has_prefetched_wallpaper(self) -> bool:
        """Check if a prefetched wallpaper is available
        
        Returns:
            True if a wallpaper is ready in next_random_dir
        """
        if not self.config.next_random_dir.exists():
            return False
        
        # Check if directory contains any wallpaper files
        for file_path in self.config.next_random_dir.iterdir():
            if file_path.is_file() and file_path.suffix.lower() in {'.jxl', '.jpg', '.jpeg', '.png', '.webp'}:
                return True
        
        return False
    
    def get_prefetched_wallpaper(self) -> Optional[Path]:
        """Get the first prefetched wallpaper file
        
        Returns:
            Path to prefetched wallpaper or None if not available
        """
        if not self.config.next_random_dir.exists():
            return None
        
        # Find first wallpaper file in next_random_dir
        for file_path in self.config.next_random_dir.iterdir():
            if file_path.is_file() and file_path.suffix.lower() in {'.jxl', '.jpg', '.jpeg', '.png', '.webp'}:
                return file_path
        
        return None
    
    def move_prefetched_to_current(self) -> Optional[Path]:
        """Move prefetched wallpaper to current directory and return its new path
        
        Returns:
            Path to wallpaper in current directory or None if no prefetched wallpaper
        """
        prefetched_path = self.get_prefetched_wallpaper()
        if not prefetched_path:
            return None
        
        # Clear current directory first
        clear_directory_contents(self.config.current_random_dir)
        
        # Move prefetched wallpaper to current directory
        new_path = self.config.current_random_dir / prefetched_path.name
        shutil.move(str(prefetched_path), str(new_path))
        
        return new_path
    
    def start_background_prefetch(self, search_params: Dict[str, Any], 
                                  search: WallhavenSearch, 
                                  downloader: WallpaperDownloader) -> threading.Thread:
        """Start background thread to prefetch next wallpaper
        
        Args:
            search_params: Search parameters (resolution, categories, purity, max_items, percentage_of_items)
            search: WallhavenSearch instance to use
            downloader: WallpaperDownloader instance to use
            
        Returns:
            Thread object that can be joined
        """
        # Start background thread (not daemon - we want to wait for it)
        thread = threading.Thread(
            target=self._prefetch_wallpaper_worker,
            args=(search_params, search, downloader)
        )
        thread.start()
        return thread
    
    def _prefetch_wallpaper_worker(self, search_params: Dict[str, Any], 
                                   search: WallhavenSearch, 
                                   downloader: WallpaperDownloader) -> None:
        """Worker function to download next wallpaper in background
        
        Args:
            search_params: Search parameters for wallpaper
            search: WallhavenSearch instance to use
            downloader: WallpaperDownloader instance to use
        """
        try:
            
            # Search for a random wallpaper
            wallpaper_data = search.search_random_wallpaper(**search_params)
            
            if not wallpaper_data:
                return  # Silently fail for background operation
            
            # Clear next directory first
            clear_directory_contents(self.config.next_random_dir)
            
            # Download directly to next_random_dir
            download_result = downloader.download_wallpaper(
                wallpaper_data, 
                target_dir=self.config.next_random_dir
            )
            
            # If download was cached from elsewhere, copy to next dir
            if download_result.success and download_result.was_cached:
                cached_file = download_result.file_path
                if cached_file and cached_file.parent != self.config.next_random_dir:
                    # Copy cached file to next directory
                    new_path = self.config.next_random_dir / cached_file.name
                    if not new_path.exists():  # Avoid overwriting
                        shutil.copy2(str(cached_file), str(new_path))
            
        except Exception:
            # Silently fail for background operation
            pass
    
