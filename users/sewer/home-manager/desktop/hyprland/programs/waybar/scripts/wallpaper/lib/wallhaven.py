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
from .downloaders.base import BaseDownloader
from .file_manager import WallpaperFileManager


class WallhavenCollectionDownloader(BaseDownloader):
    """Downloads wallpapers from Wallhaven collections with JXL conversion"""
    
    def _get_default_download_dir(self) -> Path:
        """Get default download directory for collection downloads"""
        return Path.home() / "Pictures" / "wallpapers" / "wallhaven"
    
    def _post_process_download(self, downloaded_path: Path, wallpaper_id: str) -> Path:
        """Convert downloaded wallpaper to JXL format
        
        Args:
            downloaded_path: Path to downloaded file
            wallpaper_id: Wallpaper ID
            
        Returns:
            Path to final file (JXL if conversion succeeded, original otherwise)
        """
        from .jxl_utils import JXLConverter
        
        jxl_path = self.download_dir / f"{wallpaper_id}.jxl"
        conversion_result = JXLConverter.convert_to_jxl(
            downloaded_path, jxl_path, remove_source=True
        )
        
        if conversion_result.success:
            return jxl_path
        else:
            return downloaded_path


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
        self.downloader = WallhavenCollectionDownloader(cache_dir)
    
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
        return self.downloader.download_wallpaper(wallpaper_data)
    
