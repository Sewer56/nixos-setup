#!/usr/bin/env python3

"""
Wallhaven search functionality with caching
"""

import random
from typing import Dict, Optional, List, Any
from pathlib import Path
import subprocess
from urllib.request import urlopen, Request

from .wallhaven_api import WallhavenAPI
from .cache_manager import CacheManager
from .results import DownloadResult


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


class WallpaperDownloader:
    """Handles downloading wallpapers from Wallhaven"""
    
    def __init__(self, download_dir: Optional[Path] = None):
        """Initialize downloader
        
        Args:
            download_dir: Directory to save wallpapers.
                         Defaults to ~/Pictures/wallpapers/downloads
        """
        if download_dir is None:
            download_dir = Path.home() / "Pictures" / "wallpapers" / "downloads"
        self.download_dir = Path(download_dir)
        self.download_dir.mkdir(parents=True, exist_ok=True)
    
    def download_wallpaper(self, wallpaper_data: Dict[str, Any]) -> DownloadResult:
        """Download a wallpaper from Wallhaven
        
        Args:
            wallpaper_data: Wallpaper data from API
            
        Returns:
            DownloadResult with download status
        """
        wallpaper_id = wallpaper_data.get('id')
        wallpaper_url = wallpaper_data.get('path')
        
        if not wallpaper_id or not wallpaper_url:
            return DownloadResult(
                success=False,
                wallpaper_id=wallpaper_id or "unknown",
                error_message="Missing wallpaper ID or URL"
            )
        
        # Check if already downloaded (as JXL)
        jxl_path = self.download_dir / f"{wallpaper_id}.jxl"
        if jxl_path.exists():
            return DownloadResult(
                success=True,
                wallpaper_id=wallpaper_id,
                file_path=jxl_path,
                was_cached=True
            )
        
        # Check for other formats
        for ext in ['.jpg', '.jpeg', '.png', '.webp']:
            existing_path = self.download_dir / f"{wallpaper_id}{ext}"
            if existing_path.exists():
                return DownloadResult(
                    success=True,
                    wallpaper_id=wallpaper_id,
                    file_path=existing_path,
                    was_cached=True
                )
        
        try:
            # Download wallpaper
            file_extension = Path(wallpaper_url).suffix
            temp_path = self.download_dir / f"{wallpaper_id}{file_extension}"
            
            request = Request(wallpaper_url, headers={
                'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
            })
            
            with urlopen(request, timeout=60) as response:
                with open(temp_path, 'wb') as f:
                    f.write(response.read())
            
            # Try to convert to JXL if cjxl is available
            try:
                result = subprocess.run(
                    ['cjxl', str(temp_path), str(jxl_path)],
                    capture_output=True,
                    text=True,
                    check=True
                )
                
                # If conversion successful, remove original
                temp_path.unlink()
                
                return DownloadResult(
                    success=True,
                    wallpaper_id=wallpaper_id,
                    file_path=jxl_path,
                    was_cached=False
                )
                
            except (subprocess.CalledProcessError, FileNotFoundError):
                # cjxl not available or conversion failed, keep original
                return DownloadResult(
                    success=True,
                    wallpaper_id=wallpaper_id,
                    file_path=temp_path,
                    was_cached=False
                )
                
        except Exception as e:
            return DownloadResult(
                success=False,
                wallpaper_id=wallpaper_id,
                error_message=str(e)
            )