#!/usr/bin/env python3

"""
Wallpaper file management utilities
"""

from pathlib import Path
from typing import Optional, List


class WallpaperFileManager:
    """Handles wallpaper file discovery and management"""
    
    # Supported wallpaper formats in order of preference
    SUPPORTED_FORMATS = ['.jxl', '.jpg', '.jpeg', '.png', '.webp']
    
    @staticmethod
    def find_existing_wallpaper(wallpaper_id: str, search_dir: Path) -> Optional[Path]:
        """Find existing wallpaper file in various formats
        
        Args:
            wallpaper_id: Wallpaper ID to search for
            search_dir: Directory to search in
            
        Returns:
            Path to existing file or None if not found
        """
        if not search_dir.exists():
            return None
        
        # Check for formats in order of preference
        for ext in WallpaperFileManager.SUPPORTED_FORMATS:
            file_path = search_dir / f"{wallpaper_id}{ext}"
            if file_path.exists():
                return file_path
        
        return None
    
    @staticmethod
    def get_preferred_path(wallpaper_id: str, target_dir: Path, prefer_jxl: bool = True) -> Path:
        """Get the preferred path for a wallpaper file
        
        Args:
            wallpaper_id: Wallpaper ID
            target_dir: Target directory
            prefer_jxl: Whether to prefer JXL format
            
        Returns:
            Path to preferred file location
        """
        if prefer_jxl:
            return target_dir / f"{wallpaper_id}.jxl"
        else:
            return target_dir / f"{wallpaper_id}.jpg"
    
    @staticmethod
    def list_wallpapers_in_directory(directory: Path) -> List[str]:
        """List all wallpaper IDs in a directory
        
        Args:
            directory: Directory to search
            
        Returns:
            List of wallpaper IDs (without extensions)
        """
        if not directory.exists():
            return []
        
        wallpaper_ids = set()
        
        for file_path in directory.iterdir():
            if file_path.is_file() and file_path.suffix.lower() in WallpaperFileManager.SUPPORTED_FORMATS:
                wallpaper_ids.add(file_path.stem)
        
        return sorted(list(wallpaper_ids))
    
    @staticmethod
    def is_supported_format(file_path: Path) -> bool:
        """Check if a file is in a supported wallpaper format
        
        Args:
            file_path: Path to check
            
        Returns:
            True if format is supported, False otherwise
        """
        return file_path.suffix.lower() in WallpaperFileManager.SUPPORTED_FORMATS
    
    @staticmethod
    def ensure_directory_exists(directory: Path) -> None:
        """Ensure a directory exists, creating it if necessary
        
        Args:
            directory: Directory path to ensure exists
        """
        directory.mkdir(parents=True, exist_ok=True)