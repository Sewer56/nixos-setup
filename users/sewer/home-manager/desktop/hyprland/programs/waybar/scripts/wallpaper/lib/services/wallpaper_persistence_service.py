#!/usr/bin/env python3

"""
Wallpaper persistence service for saving and converting wallpapers
"""

from pathlib import Path

from ..core.results import WallpaperResult
from ..config import WallpaperConfig
from ..converters.jxl import JXLConverter


class WallpaperPersistenceService:
    """Service for wallpaper saving and format conversion operations"""
    
    def __init__(self, config: WallpaperConfig):
        """Initialize wallpaper persistence service
        
        Args:
            config: WallpaperConfig instance
        """
        self.config = config
        self.saved_dir = config.saved_dir
    
    def convert_wallpaper_to_jxl(self, source_path: Path, remove_source: bool = False, overwrite: bool = False) -> WallpaperResult:
        """Convert a wallpaper to JXL format and save to saved directory
        
        Args:
            source_path: Path to source wallpaper file
            remove_source: Whether to remove the source file after conversion
            overwrite: Whether to overwrite existing files
            
        Returns:
            WallpaperResult with success status and details
        """
        if not source_path.exists():
            return WallpaperResult(
                success=False,
                wallpaper_path=source_path,
                error_message=f"Source wallpaper file not found: {source_path}"
            )
        
        jxl_path = self.saved_dir / f"{source_path.stem}.jxl"
        return JXLConverter.convert_to_jxl(
            source_path=source_path,
            target_path=jxl_path,
            remove_source=remove_source,
            overwrite=overwrite
        )