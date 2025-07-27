#!/usr/bin/env python3

"""
Wallpaper management utilities for Hyprland
"""

import random
import subprocess
from pathlib import Path
from typing import List, Optional

from .results import WallpaperResult


class WallpaperManager:
    """Manages wallpaper operations for Hyprland"""
    
    SUPPORTED_EXTENSIONS = {'.jxl', '.jpg', '.jpeg', '.png', '.webp'}
    
    def __init__(self, wallpaper_dir: Optional[str] = None):
        """Initialize wallpaper manager
        
        Args:
            wallpaper_dir: Directory containing wallpapers. Defaults to ~/Pictures/wallpapers
        """
        if wallpaper_dir is None:
            wallpaper_dir = Path.home() / "Pictures" / "wallpapers"
        self.wallpaper_dir = Path(wallpaper_dir)
        
        # Define subdirectories
        self.wallhaven_dir = self.wallpaper_dir / "wallhaven"
        self.saved_dir = self.wallpaper_dir / "saved"
        self.temp_dir = self.wallpaper_dir / "temp"
    
    def get_wallpapers(self) -> List[Path]:
        """Get list of all available wallpaper files
        
        Returns:
            List of Path objects for wallpaper files
        """
        wallpapers = []
        
        # Search in all directories including root
        search_dirs = [self.wallpaper_dir, self.wallhaven_dir, self.saved_dir, self.temp_dir]
        
        for search_dir in search_dirs:
            if search_dir.exists():
                for ext in self.SUPPORTED_EXTENSIONS:
                    # Use glob instead of rglob to avoid duplicates from subdirectories
                    wallpapers.extend(search_dir.glob(f"*{ext}"))
        
        return sorted(list(set(wallpapers)))  # Remove duplicates and sort
    
    def get_favorite_wallpapers(self) -> List[Path]:
        """Get list of wallpapers from favorites sources only (wallhaven + saved)
        
        Returns:
            List of Path objects for favorite wallpaper files
        """
        wallpapers = []
        
        # Only search in wallhaven and saved directories
        search_dirs = [self.wallhaven_dir, self.saved_dir]
        
        for search_dir in search_dirs:
            if search_dir.exists():
                for ext in self.SUPPORTED_EXTENSIONS:
                    wallpapers.extend(search_dir.glob(f"*{ext}"))
        
        return sorted(wallpapers)
    
    def get_current_wallpaper(self) -> Optional[Path]:
        """Get the currently active wallpaper
        
        Returns:
            Path to current wallpaper file, or None if no wallpaper is active
        """
        try:
            result = subprocess.run(['hyprctl', 'hyprpaper', 'listactive'], 
                                  check=True, capture_output=True, text=True)
            output = result.stdout.strip()
            
            if output and output != "no wallpapers loaded":
                # Extract wallpaper path from output
                # Format is typically: "monitor = wallpaper_path"
                lines = output.split('\n')
                for line in lines:
                    if ' = ' in line:
                        wallpaper_path = line.split(' = ', 1)[1].strip()
                        return Path(wallpaper_path)
            
            return None
            
        except subprocess.CalledProcessError:
            return None
    
    def get_random_wallpaper(self) -> Optional[Path]:
        """Get a random wallpaper from favorites collection, excluding current wallpaper
        
        Returns:
            Path to random wallpaper file, or None if no wallpapers found or only current wallpaper available
        """
        wallpapers = self.get_favorite_wallpapers()
        if not wallpapers:
            return None
        
        current_wallpaper = self.get_current_wallpaper()
        
        # Filter out current wallpaper from choices
        if current_wallpaper:
            available_wallpapers = [w for w in wallpapers if w != current_wallpaper]
            # If no different wallpapers available, return None
            if not available_wallpapers:
                return None
            wallpapers = available_wallpapers
        
        return random.choice(wallpapers)
    
    def set_wallpaper(self, wallpaper_path: Path) -> WallpaperResult:
        """Set wallpaper using hyprctl
        
        Args:
            wallpaper_path: Path to wallpaper file
            
        Returns:
            WallpaperResult with success status and details
        """
        if not wallpaper_path.exists():
            return WallpaperResult(
                success=False,
                wallpaper_path=wallpaper_path,
                error_message=f"Wallpaper file not found: {wallpaper_path}"
            )
        
        try:
            # Use reload command which combines preload, set, and unload in one step
            # Syntax: hyprctl hyprpaper reload ",<wallpaper_path>" (empty monitor = all monitors)
            subprocess.run(['hyprctl', 'hyprpaper', 'reload', f',{wallpaper_path}'], 
                         check=True, capture_output=True)
            
            return WallpaperResult(
                success=True,
                wallpaper_path=wallpaper_path
            )
            
        except subprocess.CalledProcessError as e:
            return WallpaperResult(
                success=False,
                wallpaper_path=wallpaper_path,
                error_message=f"hyprctl error: {e}"
            )
    
    
    def set_random_wallpaper(self) -> WallpaperResult:
        """Set a random wallpaper from favorites, excluding the currently active one
        
        Returns:
            WallpaperResult with success status and details
        """
        favorite_wallpapers = self.get_favorite_wallpapers()
        if not favorite_wallpapers:
            return WallpaperResult(
                success=False,
                error_message=f"No favorite wallpapers found in wallhaven or saved directories"
            )
        
        random_wallpaper = self.get_random_wallpaper()
        if not random_wallpaper:
            # This means only the current wallpaper is available (no alternatives)
            return WallpaperResult(
                success=False,
                error_message="No different wallpaper available - current wallpaper excluded"
            )
        
        return self.set_wallpaper(random_wallpaper)
    
    def set_specific_wallpaper(self, wallpaper_name: str) -> WallpaperResult:
        """Set a specific wallpaper by name
        
        Args:
            wallpaper_name: Name of the wallpaper file
            
        Returns:
            WallpaperResult with success status and details
        """
        wallpaper_path = self.wallpaper_dir / wallpaper_name
        
        if not wallpaper_path.exists():
            return WallpaperResult(
                success=False,
                wallpaper_path=wallpaper_path,
                error_message=f"Wallpaper not found: {wallpaper_name}"
            )
        
        return self.set_wallpaper(wallpaper_path)
    
    def save_current_wallpaper(self) -> WallpaperResult:
        """Save the current wallpaper to the saved directory with JXL conversion
        
        Returns:
            WallpaperResult with success status and details
        """
        from .jxl_utils import JXLConverter
        
        current_wallpaper = self.get_current_wallpaper()
        if not current_wallpaper:
            return WallpaperResult(
                success=False,
                error_message="No current wallpaper to save"
            )
        
        # Use JXL utility to copy with conversion
        return JXLConverter.copy_with_jxl_conversion(
            source_path=current_wallpaper,
            target_dir=self.saved_dir,
            target_name=current_wallpaper.stem
        )