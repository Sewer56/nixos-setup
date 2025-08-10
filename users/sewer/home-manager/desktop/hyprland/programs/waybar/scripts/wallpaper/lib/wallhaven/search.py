#!/usr/bin/env python3

"""
Wallhaven search functionality with caching
"""

import random
from typing import Dict, Optional, Any

from .client import WallhavenClient
from ..core.cache_manager import CacheManager
from ..constants import ITEMS_PER_PAGE

class WallhavenSearch:
    """Handles wallpaper searches with caching"""
    
    def __init__(self, api_client: WallhavenClient, cache_manager: CacheManager, cache_max_age_days: int = 7):
        """Initialize search manager
        
        Args:
            api_client: Wallhaven API client
            cache_manager: Cache manager instance
            cache_max_age_days: Maximum age for cache entries in days (defaults to 7)
        """
        self.api = api_client
        self.cache = cache_manager
        self.cache_max_age_days = cache_max_age_days
    
    def search_random_wallpaper(self, min_resolution: str, 
                              categories: str = '110', 
                              purity: str = '100',
                              max_items: int = 10000,
                              percentage_of_items: float = 0.1,
                              ratios: Optional[str] = None) -> Optional[Dict[str, Any]]:
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
            max_items: Maximum number of wallpapers to consider (default: 10000)
            percentage_of_items: Percentage of total available wallpapers (0.0-1.0, default: 0.1)
            ratios: Aspect ratio filter (e.g., "16x9,21x9" or None for any ratio)
                   
        Returns:
            Random wallpaper data or None if search failed
        """
        # Generate cache key for total count
        total_cache_key = self.cache.generate_search_key(
            min_resolution=min_resolution,
            categories=categories,
            purity=purity,
            ratios=ratios,
            search_type='total_count'
        )
        
        # Get total available wallpapers from cache, or fetch if not available
        cached_total = self.cache.get(total_cache_key, max_age_days=self.cache_max_age_days)
        if cached_total and 'total_available' in cached_total:
            total_available = cached_total['total_available']
        else:
            # Fetch first page to get total count
            first_page_data = self._fetch_page_with_metadata(1, min_resolution, categories, purity, ratios)
            if not first_page_data:
                return None
            
            total_available = first_page_data['total_available']
            # Cache the total count
            self.cache.set(total_cache_key, {'total_available': total_available})
        
        # Calculate target pool size from parameters
        from_percentage = int(percentage_of_items * total_available)
        target_size = min(max_items, from_percentage)
        if target_size <= 0:
            return None
        
        # Pick random index within target size
        random_index = random.randint(0, min(target_size, total_available) - 1)
        
        # Calculate which page this index falls on (pages start at 1)
        page_num = (random_index // ITEMS_PER_PAGE) + 1
        index_in_page = random_index % ITEMS_PER_PAGE
        
        # Generate cache key for this specific page
        page_cache_key = self.cache.generate_search_key(
            min_resolution=min_resolution,
            categories=categories,
            purity=purity,
            ratios=ratios,
            search_type='page',
            page_num=page_num
        )
        
        # Check if we already have this page cached
        cached_page = self.cache.get(page_cache_key, max_age_days=self.cache_max_age_days)
        if cached_page and 'wallpapers' in cached_page:
            wallpapers = cached_page['wallpapers']
        else:
            # Fetch the specific page and cache it
            page_data = self._fetch_page_with_metadata(page_num, min_resolution, categories, purity, ratios)
            if not page_data:
                return None
            
            wallpapers = page_data['wallpapers']
            # Cache this page for future use
            self.cache.set(page_cache_key, {'wallpapers': wallpapers})
        
        if wallpapers and index_in_page < len(wallpapers):
            return wallpapers[index_in_page]
        
        return None
    
    
    def _fetch_page_with_metadata(self, page_num: int, min_resolution: str, 
                                categories: str, purity: str, ratios: Optional[str] = None) -> Optional[Dict[str, Any]]:
        """Fetch wallpapers from a specific page with metadata
        
        Args:
            page_num: Page number to fetch
            min_resolution: Minimum resolution
            categories: Category filter
            purity: Purity filter
            ratios: Aspect ratio filter (optional)
            
        Returns:
            Dict with 'wallpapers' and 'total_available' or None if failed
        """
        try:
            params = {
                'categories': categories,
                'purity': purity,
                'sorting': 'favorites',
                'order': 'desc',
                'topRange': '1y',
                'atleast': min_resolution,
                'page': page_num
            }
            
            # Add ratios filter if specified
            if ratios:
                params['ratios'] = ratios
            
            response = self.api.search(params)
            if 'data' in response and 'meta' in response:
                return {
                    'wallpapers': response['data'],
                    'total_available': response['meta'].get('total', 10800)  # fallback
                }
        except Exception:
            pass
        
        return None