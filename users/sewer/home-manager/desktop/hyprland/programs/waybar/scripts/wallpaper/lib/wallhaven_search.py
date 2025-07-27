#!/usr/bin/env python3

"""
Wallhaven search functionality with caching
"""

import random
from typing import Dict, Optional, List, Any
from pathlib import Path

from .wallhaven_api import WallhavenAPI
from .cache_manager import CacheManager
from .downloaders.base import BaseDownloader


class WallhavenSearch:
    """Handles wallpaper searches with caching"""
    
    def __init__(self, api_client: WallhavenAPI, cache_manager: CacheManager):
        """Initialize search manager
        
        Args:
            api_client: Wallhaven API client
            cache_manager: Cache manager instance
        """
        self.api = api_client
        self.cache = cache_manager
    
    def search_random_wallpaper(self, min_resolution: str, 
                              categories: str = '110', 
                              purity: str = '100') -> Optional[Dict[str, Any]]:
        """Search for a random wallpaper matching criteria
        
        Args:
            min_resolution: Minimum resolution (e.g., "1920x1080")
            categories: Category filter (default '110' for general+anime)
                       - First digit: general (1=yes, 0=no)
                       - Second digit: anime (1=yes, 0=no)
                       - Third digit: people (1=yes, 0=no)
            purity: Purity filter (default '100' for SFW only)
                   - First digit: SFW (1=yes, 0=no)
                   - Second digit: sketchy (1=yes, 0=no)
                   - Third digit: NSFW (1=yes, 0=no)
                   
        Returns:
            Random wallpaper data or None if search failed
        """
        # Generate cache key
        cache_key = self.cache.generate_search_key(
            min_resolution=min_resolution,
            categories=categories,
            purity=purity,
            search_type='random_top1000'
        )
        
        # Check cache first
        cached_data = self.cache.get(cache_key, max_age_days=7)
        
        if cached_data and 'wallpapers' in cached_data:
            # Return random wallpaper from cached results
            return random.choice(cached_data['wallpapers'])
        
        # Perform API search
        wallpapers = self._fetch_top_wallpapers(
            min_resolution=min_resolution,
            categories=categories,
            purity=purity
        )
        
        if wallpapers:
            # Cache the results
            self.cache.set(cache_key, {'wallpapers': wallpapers})
            
            # Return random wallpaper
            return random.choice(wallpapers)
        
        return None
    
    def _fetch_top_wallpapers(self, min_resolution: str, 
                            categories: str, 
                            purity: str) -> List[Dict[str, Any]]:
        """Fetch top wallpapers from API
        
        Args:
            min_resolution: Minimum resolution
            categories: Category filter
            purity: Purity filter
            
        Returns:
            List of wallpaper data
        """
        wallpapers = []
        
        try:
            # To get approximately top 1000, fetch multiple pages
            # API returns 24 results per page, so ~42 pages for 1000 results
            # But we'll fetch fewer pages and randomize from those
            num_pages = 10  # Fetch 240 wallpapers
            
            for page in range(1, num_pages + 1):
                params = {
                    'categories': categories,
                    'purity': purity,
                    'sorting': 'favorites',
                    'order': 'desc',
                    'topRange': '1y',  # Top from last year
                    'atleast': min_resolution,
                    'page': page
                }
                
                try:
                    response = self.api.search(params)
                    if 'data' in response:
                        wallpapers.extend(response['data'])
                except Exception:
                    # Continue fetching other pages even if one fails
                    continue
                
        except Exception:
            pass
        
        return wallpapers
    
    def search_by_color(self, color: str, min_resolution: str,
                       categories: str = '110',
                       purity: str = '100') -> Optional[Dict[str, Any]]:
        """Search for wallpapers by color (for future implementation)
        
        Args:
            color: Hex color code
            min_resolution: Minimum resolution
            categories: Category filter
            purity: Purity filter
            
        Returns:
            Random wallpaper matching color or None
        """
        # This would be implemented when color matching is added
        # For now, just return None
        return None


class WallpaperDownloader(BaseDownloader):
    """Handles downloading wallpapers from Wallhaven search without JXL conversion"""
    
    def _get_default_download_dir(self) -> Path:
        """Get default download directory for search downloads"""
        return Path.home() / "Pictures" / "wallpapers" / "downloads"
    
    def _post_process_download(self, downloaded_path: Path, wallpaper_id: str) -> Path:
        """No post-processing for search downloads - keep original format
        
        Args:
            downloaded_path: Path to downloaded file
            wallpaper_id: Wallpaper ID
            
        Returns:
            Path to original downloaded file
        """
        return downloaded_path
    
    
    def clear_temp_directory(self) -> None:
        """Clear all files from the temp directory"""
        self.clear_directory()