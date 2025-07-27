#!/usr/bin/env python3

"""
Wallhaven wallpaper downloader
"""

from pathlib import Path
from typing import Dict, Any
from urllib.request import urlopen, Request

from ..core.results import DownloadResult
from pathlib import Path as PathType
from typing import Optional
from ..constants import USER_AGENT, DEFAULT_TIMEOUT


class WallpaperDownloader:
    """Handles downloading wallpapers from Wallhaven"""
    
    def __init__(self, config):
        """Initialize downloader
        
        Args:
            config: WallpaperConfig instance
        """
        self.config = config
        self.config.temp_dir.mkdir(parents=True, exist_ok=True)
    
    def download_wallpaper(self, wallpaper_data: Dict[str, Any]) -> DownloadResult:
        """Download a wallpaper if not already cached
        
        Args:
            wallpaper_data: Wallpaper data typically returned from a search operation.
                            Must contain 'id' and 'path' keys at minimum.
                           
                            Example search result:
                            {
                                'id': '8572jd',
                                'path': 'https://w.wallhaven.cc/full/8z/wallhaven-8572jd.jpg',
                                'resolution': '1920x1080'
                            }
            
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
        
        # Check if already cached
        existing_file = self._find_existing_wallpaper(wallpaper_id)
        if existing_file:
            return DownloadResult(
                success=True,
                wallpaper_id=wallpaper_id,
                file_path=existing_file,
                was_cached=True
            )
        
        try:
            return self._perform_download(wallpaper_id, wallpaper_url)
        except Exception as e:
            return DownloadResult(
                success=False,
                wallpaper_id=wallpaper_id,
                error_message=str(e)
            )
    
    def _perform_download(self, wallpaper_id: str, wallpaper_url: str) -> DownloadResult:
        """Perform the actual download operation
        
        Args:
            wallpaper_id: Wallpaper ID
            wallpaper_url: Wallpaper URL
            
        Returns:
            DownloadResult with download status
        """
        request = Request(wallpaper_url, headers={'User-Agent': USER_AGENT})
        
        file_extension = Path(wallpaper_url).suffix
        temp_path = self.config.temp_dir / f"{wallpaper_id}{file_extension}"
        
        with urlopen(request, timeout=DEFAULT_TIMEOUT) as response:
            with open(temp_path, 'wb') as f:
                f.write(response.read())
        
        return DownloadResult(
            success=True,
            wallpaper_id=wallpaper_id,
            file_path=temp_path,
            was_cached=False
        )
    
    def clear_temp_directory(self) -> None:
        """Clear all files from the temp directory"""
        if self.config.temp_dir.exists():
            for file_path in self.config.temp_dir.iterdir():
                if file_path.is_file():
                    try:
                        file_path.unlink()
                    except Exception:
                        pass
    
    # Supported wallpaper formats in order of preference
    SUPPORTED_FORMATS = ['.jxl', '.jpg', '.jpeg', '.png', '.webp']
    
    def _find_existing_wallpaper(self, wallpaper_id: str) -> Optional[PathType]:
        """Find existing wallpaper file in various formats across all directories
        
        Args:
            wallpaper_id: Wallpaper ID to search for
            
        Returns:
            Path to existing file or None if not found
        """
        # Get search directories - prioritize saved over temp
        search_dirs = [self.config.saved_dir, self.config.base_dir, self.config.temp_dir]
        
        # Check for formats in order of preference across all directories
        for search_dir in search_dirs:
            if not search_dir.exists():
                continue
                
            for ext in self.SUPPORTED_FORMATS:
                file_path = search_dir / f"{wallpaper_id}{ext}"
                if file_path.exists():
                    return file_path
        
        return None