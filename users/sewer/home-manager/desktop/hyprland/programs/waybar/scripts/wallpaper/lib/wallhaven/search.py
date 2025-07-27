#!/usr/bin/env python3

"""
Wallhaven search functionality with caching
"""

import random
from typing import Dict, Optional, List, Any

from .client import WallhavenClient
from ..core.cache_manager import CacheManager

class WallhavenSearch:
    """Handles wallpaper searches with caching"""
    
    def __init__(self, api_client: WallhavenClient, cache_manager: CacheManager):
        """Initialize search manager
        
        Args:
            api_client: Wallhaven API client
            cache_manager: Cache manager instance
        """
        self.api = api_client
        self.cache = cache_manager
    
    def search_random_wallpaper(self, min_resolution: str, 
                              categories: str = '110', 
                              purity: str = '100',
                              max_pages: int = 10) -> Optional[Dict[str, Any]]:
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
            max_pages: Maximum pages to fetch from API (default 10, ~240 wallpapers)
                   
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
            purity=purity,
            max_pages=max_pages
        )
        
        if wallpapers:
            # Cache the results
            self.cache.set(cache_key, {'wallpapers': wallpapers})
            
            # Return random wallpaper
            return random.choice(wallpapers)
        
        return None
    
    def _fetch_top_wallpapers(self, min_resolution: str, 
                            categories: str, 
                            purity: str,
                            max_pages: int = 10) -> List[Dict[str, Any]]:
        """Fetch top wallpapers from API
        
        Args:
            min_resolution: Minimum resolution
            categories: Category filter
            purity: Purity filter
            max_pages: Maximum pages to fetch (default 10)
            
        Returns:
            List of wallpaper data
        """
        wallpapers = []
        
        try:
            # Fetch wallpapers from multiple pages
            # API returns 24 results per page
            for page in range(1, max_pages + 1):
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