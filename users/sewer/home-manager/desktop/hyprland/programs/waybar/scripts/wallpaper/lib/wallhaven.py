#!/usr/bin/env python3

"""
Wallhaven API integration for wallpaper management
"""

import json
import time
from pathlib import Path
from typing import List, Optional
from urllib.request import urlopen, Request
from urllib.error import URLError

from .results import DownloadResult


class WallhavenManager:
    """Manages Wallhaven API interactions and wallpaper downloads"""
    
    API_URL = "https://wallhaven.cc/api/v1/collections/sewer56/1951389"
    MAX_RETRIES = 8
    BASE_RETRY_DELAY = 1
    USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
    
    def __init__(self, cache_dir: Optional[str] = None):
        """Initialize Wallhaven manager
        
        Args:
            cache_dir: Directory to cache wallpapers. Defaults to ~/Pictures/wallpapers/wallhaven
        """
        if cache_dir is None:
            cache_dir = Path.home() / "Pictures" / "wallpapers" / "wallhaven"
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
    
    def fetch_collection_with_retry(self) -> Optional[List[dict]]:
        """Fetch wallpaper collection with exponential backoff retry
        
        Returns:
            List of wallpaper dictionaries or None if failed
        """
        for attempt in range(self.MAX_RETRIES):
            try:
                request = Request(self.API_URL, headers={'User-Agent': self.USER_AGENT})
                with urlopen(request, timeout=10) as response:
                    data = json.loads(response.read().decode())
                    return data.get('data', [])
            except (URLError, json.JSONDecodeError, Exception) as e:
                delay = self.BASE_RETRY_DELAY * (2 ** attempt)
                if attempt < self.MAX_RETRIES - 1:
                    time.sleep(delay)
                else:
                    # Return None and let caller handle the error
                    pass
        return None
    
    def download_wallpaper(self, wallpaper_data: dict) -> DownloadResult:
        """Download a single wallpaper if not already cached
        
        Args:
            wallpaper_data: Wallpaper data from API
            
        Returns:
            DownloadResult with success status and details
        """
        from .jxl_utils import JXLConverter
        
        wallpaper_id = wallpaper_data.get('id')
        wallpaper_url = wallpaper_data.get('path')
        
        if not wallpaper_id or not wallpaper_url:
            return DownloadResult(
                success=False,
                wallpaper_id=wallpaper_id or "unknown",
                error_message="Missing wallpaper ID or URL"
            )
        
        # Check if already cached
        existing_file = JXLConverter.find_existing_wallpaper(wallpaper_id, self.cache_dir)
        if existing_file:
            return DownloadResult(
                success=True,
                wallpaper_id=wallpaper_id,
                file_path=existing_file,
                was_cached=True
            )
        
        try:
            request = Request(wallpaper_url, headers={'User-Agent': self.USER_AGENT})
            
            file_extension = Path(wallpaper_url).suffix
            temp_path = self.cache_dir / f"{wallpaper_id}{file_extension}"
            
            with urlopen(request) as response, open(temp_path, 'wb') as f:
                f.write(response.read())
            
            # Try to convert to JXL
            jxl_path = self.cache_dir / f"{wallpaper_id}.jxl"
            conversion_result = JXLConverter.convert_to_jxl(temp_path, jxl_path, remove_source=True)
            
            if conversion_result.success:
                return DownloadResult(
                    success=True,
                    wallpaper_id=wallpaper_id,
                    file_path=jxl_path,
                    was_cached=False
                )
            else:
                # Keep original file if conversion failed
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
    
