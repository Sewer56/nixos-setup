#!/usr/bin/env python3

"""
Base downloader class for wallpaper downloads
"""

from abc import ABC, abstractmethod
from pathlib import Path
from typing import Dict, Any, Optional
from urllib.request import urlopen, Request

from ..results import DownloadResult
from ..file_manager import WallpaperFileManager


class BaseDownloader(ABC):
    """Abstract base class for wallpaper downloaders"""
    
    USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
    DEFAULT_TIMEOUT = 60
    
    def __init__(self, download_dir: Optional[Path] = None):
        """Initialize downloader
        
        Args:
            download_dir: Directory to save wallpapers
        """
        if download_dir is None:
            download_dir = self._get_default_download_dir()
        self.download_dir = Path(download_dir)
        WallpaperFileManager.ensure_directory_exists(self.download_dir)
    
    @abstractmethod
    def _get_default_download_dir(self) -> Path:
        """Get the default download directory for this downloader type
        
        Returns:
            Default download directory path
        """
        pass
    
    def download_wallpaper(self, wallpaper_data: Dict[str, Any]) -> DownloadResult:
        """Download a wallpaper if not already cached
        
        Args:
            wallpaper_data: Wallpaper data containing id and path/url
            
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
        existing_file = WallpaperFileManager.find_existing_wallpaper(
            wallpaper_id, self.download_dir
        )
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
        request = Request(wallpaper_url, headers={'User-Agent': self.USER_AGENT})
        
        file_extension = Path(wallpaper_url).suffix
        temp_path = self.download_dir / f"{wallpaper_id}{file_extension}"
        
        with urlopen(request, timeout=self.DEFAULT_TIMEOUT) as response:
            with open(temp_path, 'wb') as f:
                f.write(response.read())
        
        # Apply post-processing (conversion, etc.)
        final_path = self._post_process_download(temp_path, wallpaper_id)
        
        return DownloadResult(
            success=True,
            wallpaper_id=wallpaper_id,
            file_path=final_path,
            was_cached=False
        )
    
    @abstractmethod
    def _post_process_download(self, downloaded_path: Path, wallpaper_id: str) -> Path:
        """Post-process the downloaded file (e.g., convert to JXL)
        
        Args:
            downloaded_path: Path to downloaded file
            wallpaper_id: Wallpaper ID
            
        Returns:
            Path to final processed file
        """
        pass
    
    def clear_directory(self) -> None:
        """Clear all files from the download directory"""
        if self.download_dir.exists():
            for file_path in self.download_dir.iterdir():
                if file_path.is_file():
                    try:
                        file_path.unlink()
                    except Exception:
                        pass