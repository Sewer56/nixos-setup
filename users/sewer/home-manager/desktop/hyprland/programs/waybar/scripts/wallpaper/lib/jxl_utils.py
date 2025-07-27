#!/usr/bin/env python3

"""
JXL conversion utilities for wallpaper management
"""

import subprocess
import shutil
from pathlib import Path
from typing import Tuple, Optional

from .results import WallpaperResult


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
                      remove_source: bool = True) -> WallpaperResult:
        """Convert an image to JXL format
        
        Args:
            source_path: Source image file path
            target_path: Target JXL file path
            remove_source: Whether to remove source file after successful conversion
            
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
    
    @staticmethod
    def copy_with_jxl_conversion(source_path: Path, target_dir: Path, 
                               target_name: Optional[str] = None) -> WallpaperResult:
        """Copy a file to target directory with optional JXL conversion
        
        Args:
            source_path: Source image file path
            target_dir: Target directory
            target_name: Target filename (without extension). If None, uses source stem
            
        Returns:
            WallpaperResult with copy/conversion status
        """
        if not source_path.exists():
            return WallpaperResult(
                success=False,
                wallpaper_path=source_path,
                error_message=f"Source file not found: {source_path}"
            )
        
        # Ensure target directory exists
        target_dir.mkdir(parents=True, exist_ok=True)
        
        # Determine target filename
        if target_name is None:
            target_name = source_path.stem
        
        # Try JXL conversion first
        if JXLConverter.is_cjxl_available():
            jxl_path = target_dir / f"{target_name}.jxl"
            
            # Check if JXL already exists
            if jxl_path.exists():
                return WallpaperResult(
                    success=False,
                    wallpaper_path=jxl_path,
                    error_message="Target JXL file already exists"
                )
            
            result = JXLConverter.convert_to_jxl(source_path, jxl_path, remove_source=False)
            if result.success:
                return result
        
        # Fall back to copying original file
        target_path = target_dir / f"{target_name}{source_path.suffix}"
        
        # Check if original format file already exists
        if target_path.exists():
            return WallpaperResult(
                success=False,
                wallpaper_path=target_path,
                error_message="Target file already exists"
            )
        
        try:
            shutil.copy2(source_path, target_path)
            
            return WallpaperResult(
                success=True,
                wallpaper_path=target_path
            )
            
        except Exception as e:
            return WallpaperResult(
                success=False,
                wallpaper_path=source_path,
                error_message=f"Copy failed: {e}"
            )
    
    @staticmethod
    def get_jxl_path_for_id(wallpaper_id: str, target_dir: Path) -> Path:
        """Get the JXL path for a wallpaper ID
        
        Args:
            wallpaper_id: Wallpaper ID
            target_dir: Target directory
            
        Returns:
            Path to JXL file
        """
        return target_dir / f"{wallpaper_id}.jxl"
    
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
        
        # Check for JXL first (preferred format)
        jxl_path = search_dir / f"{wallpaper_id}.jxl"
        if jxl_path.exists():
            return jxl_path
        
        # Check for other common formats
        for ext in ['.jpg', '.jpeg', '.png', '.webp']:
            file_path = search_dir / f"{wallpaper_id}{ext}"
            if file_path.exists():
                return file_path
        
        return None