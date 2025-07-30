#!/usr/bin/env python3

"""
JXL conversion utilities for wallpaper management
"""

import subprocess
from pathlib import Path
from typing import Tuple

from ..core.results import WallpaperResult

class JXLConverter:
    """Handles JXL conversion operations"""
    
    @staticmethod
    def is_cjxl_available() -> bool:
        """Check if cjxl command is available
        
        Returns:
            True if cjxl is available, False otherwise
        """
        try:
            subprocess.run(['cjxl', '--version'], 
                         capture_output=True, check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False
    
    @staticmethod
    def convert_to_jxl(source_path: Path, target_path: Path, 
                      remove_source: bool = True, overwrite: bool = False) -> WallpaperResult:
        """Convert an image to JXL format
        
        Args:
            source_path: Source image file path
            target_path: Target JXL file path
            remove_source: Whether to remove source file after successful conversion
            overwrite: Whether to overwrite existing target file
            
        Returns:
            WallpaperResult with conversion status
        """
        if not source_path.exists():
            return WallpaperResult(
                success=False,
                wallpaper_path=source_path,
                error_message=f"Source file not found: {source_path}"
            )
        
        # Ensure target directory exists
        target_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Check if target file exists and handle overwrite
        if target_path.exists() and not overwrite:
            return WallpaperResult(
                success=False,
                wallpaper_path=target_path,
                error_message="Target JXL file already exists"
            )
        
        if not JXLConverter.is_cjxl_available():
            return WallpaperResult(
                success=False,
                wallpaper_path=source_path,
                error_message="cjxl command not available"
            )
        
        try:
            subprocess.run(
                ['cjxl', str(source_path), str(target_path)],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Remove source file if requested and conversion successful
            if remove_source:
                source_path.unlink()
            
            return WallpaperResult(
                success=True,
                wallpaper_path=target_path
            )
            
        except subprocess.CalledProcessError as e:
            return WallpaperResult(
                success=False,
                wallpaper_path=source_path,
                error_message=f"JXL conversion failed: {e}"
            )
    
    
