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
class DownloadResult:
    """Result of individual wallpaper download"""
    success: bool
    wallpaper_id: str
    file_path: Optional[Path] = None
    was_cached: bool = False
    error_message: Optional[str] = None