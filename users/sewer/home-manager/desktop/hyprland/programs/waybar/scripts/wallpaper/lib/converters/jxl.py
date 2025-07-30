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
    def is_djxl_available() -> bool:
        """Check if djxl command is available
        
        Returns:
            True if djxl is available, False otherwise
        """
        try:
            subprocess.run(['djxl', '--version'], 
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
    
    @staticmethod
    def convert_from_jxl(jxl_path: Path, target_format: str = "ppm") -> Tuple[bool, Path]:
        """Convert JXL file to PIL-compatible format for analysis
        
        Args:
            jxl_path: Path to JXL file
            target_format: Target format (png, jpg, etc.)
            
        Returns:
            Tuple of (success, converted_file_path)
        """
        if not jxl_path.exists():
            return False, jxl_path
        
        if not JXLConverter.is_djxl_available():
            return False, jxl_path
        
        # Create temporary file in same directory
        temp_file = jxl_path.parent / f"{jxl_path.stem}_temp.{target_format}"
        
        try:
            subprocess.run(
                ['djxl', str(jxl_path), str(temp_file)],
                capture_output=True,
                text=True,
                check=True
            )
            
            return True, temp_file
            
        except subprocess.CalledProcessError:
            # Clean up temp file if it was created
            if temp_file.exists():
                temp_file.unlink()
            return False, jxl_path
    
    @staticmethod
    def cleanup_temp_file(temp_path: Path) -> None:
        """Clean up temporary converted file
        
        Args:
            temp_path: Path to temporary file to remove
        """
        try:
            if temp_path.exists():
                temp_path.unlink()
        except Exception:
            pass  # Ignore cleanup errors
    
