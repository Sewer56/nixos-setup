#!/usr/bin/env python3

"""
Result data structures for wallpaper operations
"""

from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional


@dataclass
class WallpaperResult:
    """Result of wallpaper setting operations"""
    success: bool
    wallpaper_path: Optional[Path] = None
    error_message: Optional[str] = None
    
    @property
    def wallpaper_name(self) -> Optional[str]:
        """Get the wallpaper filename"""
        return self.wallpaper_path.name if self.wallpaper_path else None


@dataclass
class SyncResult:
    """Result of wallpaper collection sync operations"""
    total_wallpapers: int
    downloaded_count: int
    cached_count: int
    failed_count: int
    errors: List[str]
    success: bool
    
    @property
    def new_wallpapers(self) -> int:
        """Count of newly downloaded wallpapers"""
        return self.downloaded_count
    
    @property
    def has_errors(self) -> bool:
        """Whether any errors occurred during sync"""
        return len(self.errors) > 0 or self.failed_count > 0
    
    def summary(self) -> str:
        """Get a human-readable summary of the sync operation"""
        if not self.success:
            return f"Sync failed: {self.errors[0] if self.errors else 'Unknown error'}"
        
        parts = []
        if self.downloaded_count > 0:
            parts.append(f"{self.downloaded_count} new")
        if self.cached_count > 0:
            parts.append(f"{self.cached_count} cached")
        if self.failed_count > 0:
            parts.append(f"{self.failed_count} failed")
        
        if parts:
            return f"Synced {self.total_wallpapers} wallpapers: {', '.join(parts)}"
        else:
            return f"All {self.total_wallpapers} wallpapers up to date"


@dataclass
class DownloadResult:
    """Result of individual wallpaper download"""
    success: bool
    wallpaper_id: str
    file_path: Optional[Path] = None
    was_cached: bool = False
    error_message: Optional[str] = None