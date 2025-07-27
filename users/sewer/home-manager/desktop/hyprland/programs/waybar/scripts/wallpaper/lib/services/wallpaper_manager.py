#!/usr/bin/env python3

"""
Wallpaper management coordinator with multi-monitor support
"""

from pathlib import Path
from typing import Dict, List, Optional

from ..core.results import WallpaperResult
from ..config import WallpaperConfig
from .wallpaper_discovery_service import WallpaperDiscoveryService
from .wallpaper_persistence_service import WallpaperPersistenceService
from ..hyprland.hyprland_wallpaper_service import HyprlandWallpaperService


class WallpaperManager:
    """Coordinates wallpaper operations with multi-monitor support"""
    
    def __init__(self, config: Optional[WallpaperConfig] = None):
        """Initialize wallpaper manager
        
        Args:
            config: WallpaperConfig instance. If None, uses default configuration
        """
        if config is None:
            config = WallpaperConfig()
        self.config = config
        
        # Initialize service classes
        self.discovery_service = WallpaperDiscoveryService(config)
        self.hyprland_service = HyprlandWallpaperService(config)
        self.persistence_service = WallpaperPersistenceService(config)
    
    def get_wallpapers(self) -> List[Path]:
        """Get list of all available wallpaper files
        
        Returns:
            List of Path objects for wallpaper files
        """
        return self.discovery_service.get_all_wallpapers()
    
    def get_favorite_wallpapers(self) -> List[Path]:
        """Get list of wallpapers from favorites sources only (saved)
        
        Returns:
            List of Path objects for favorite wallpaper files
        """
        return self.discovery_service.get_favorite_wallpapers()
    
    def get_current_wallpapers(self) -> Dict[str, Optional[Path]]:
        """Get currently active wallpapers for each monitor
        
        Returns:
            Dictionary mapping monitor names to wallpaper paths
        """
        return self.hyprland_service.get_current_wallpapers()
    
    def get_current_wallpaper(self, monitor_name: Optional[str] = None) -> Optional[Path]:
        """Get currently active wallpaper for a specific monitor or primary monitor
        
        Args:
            monitor_name: Monitor to get wallpaper for. If None, uses primary monitor
            
        Returns:
            Path to current wallpaper file, or None if no wallpaper is active
        """
        return self.hyprland_service.get_current_wallpaper(monitor_name)
    
    def set_wallpaper_for_monitor(self, wallpaper_path: Path, monitor_name: str) -> WallpaperResult:
        """Set wallpaper for a specific monitor
        
        Args:
            wallpaper_path: Path to wallpaper file
            monitor_name: Monitor to set wallpaper on
            
        Returns:
            WallpaperResult with success status and details
        """
        return self.hyprland_service.set_wallpaper_for_monitor(wallpaper_path, monitor_name)
    
    def set_wallpaper_all_monitors(self, wallpaper_path: Path) -> WallpaperResult:
        """Set same wallpaper on all connected monitors
        
        Args:
            wallpaper_path: Path to wallpaper file
            
        Returns:
            WallpaperResult with success status and details
        """
        return self.hyprland_service.set_wallpaper_all_monitors(wallpaper_path)
    
    def set_wallpaper(self, wallpaper_path: Path) -> WallpaperResult:
        """Set wallpaper on all monitors (maintains compatibility)
        
        Args:
            wallpaper_path: Path to wallpaper file
            
        Returns:
            WallpaperResult with success status and details
        """
        return self.set_wallpaper_all_monitors(wallpaper_path)
    
    def restore_monitor_wallpapers(self) -> Dict[str, WallpaperResult]:
        """Restore saved wallpapers for all connected monitors
        
        Returns:
            Dictionary mapping monitor names to WallpaperResult objects
        """
        return self.hyprland_service.restore_monitor_wallpapers(
            fallback_wallpaper_provider=self.get_random_wallpaper
        )
    
    def get_random_wallpaper(self) -> Optional[Path]:
        """Get a random wallpaper from favorites collection, excluding current wallpaper
        
        Returns:
            Path to random wallpaper file, or None if no wallpapers found or only current wallpaper available
        """
        current_wallpaper = self.get_current_wallpaper()
        return self.discovery_service.get_random_wallpaper(exclude_current=current_wallpaper)
    
    def set_random_wallpaper(self) -> WallpaperResult:
        """Set a random wallpaper from favorites on all monitors, excluding the currently active one
        
        Returns:
            WallpaperResult with success status and details
        """
        favorite_wallpapers = self.get_favorite_wallpapers()
        if not favorite_wallpapers:
            return WallpaperResult(
                success=False,
                error_message=f"No favorite wallpapers found in saved directories"
            )
        
        random_wallpaper = self.get_random_wallpaper()
        if not random_wallpaper:
            # This means only the current wallpaper is available (no alternatives)
            return WallpaperResult(
                success=False,
                error_message="No different wallpaper available - current wallpaper excluded"
            )
        
        return self.set_wallpaper_all_monitors(random_wallpaper)

    def save_current_wallpaper(self) -> WallpaperResult:
        """Save the current wallpaper to the saved directory with JXL conversion
        
        Returns:
            WallpaperResult with success status and details
        """
        current_wallpaper = self.get_current_wallpaper()
        if not current_wallpaper:
            return WallpaperResult(
                success=False,
                error_message="No current wallpaper to save"
            )
        
        return self.persistence_service.convert_wallpaper_to_jxl(
            source_path=current_wallpaper,
            remove_source=False,
            overwrite=False
        )
    
    def clean_missing_wallpapers(self) -> None:
        """Remove entries for wallpapers that no longer exist"""
        self.hyprland_service.state_manager.clean_missing_wallpapers()