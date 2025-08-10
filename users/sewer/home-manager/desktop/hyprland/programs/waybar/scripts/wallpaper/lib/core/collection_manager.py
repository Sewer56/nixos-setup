#!/usr/bin/env python3

"""
Declarative wallpaper collection management
"""

import json
from pathlib import Path
from typing import Dict, List, Optional

from ..config import WallpaperConfig

class CollectionManager:
    """Manages the declarative wallpaper collection"""
    
    def __init__(self, config: Optional[WallpaperConfig] = None):
        if config is None:
            config = WallpaperConfig()
        self.config = config
        self.collection_file = config.base_dir / "wallpaper_collection.json"
    
    def _load_collection(self) -> Dict:
        """Load collection file or return empty structure"""
        if not self.collection_file.exists():
            return {"version": "1.0", "wallpapers": {}}
        
        try:
            with open(self.collection_file, 'r') as f:
                collection = json.load(f)
            
            # Validate version compatibility
            if collection.get("version") != "1.0":
                raise ValueError(f"Unsupported collection version: {collection.get('version')}")
            
            # Ensure wallpapers dict exists
            if "wallpapers" not in collection:
                collection["wallpapers"] = {}
            
            return collection
        except (json.JSONDecodeError, ValueError) as e:
            # Return empty structure if file is corrupted
            return {"version": "1.0", "wallpapers": {}}
    
    def _save_collection(self, collection: Dict) -> None:
        """Save collection to file"""
        # Ensure directory exists
        self.collection_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(self.collection_file, 'w') as f:
            json.dump(collection, f, indent=2, sort_keys=True)
    
    def add_wallpaper(self, wallpaper_id: str, resolution: str, file_extension: str = ".jxl", category: Optional[str] = None) -> None:
        """Add a wallpaper to the collection"""
        collection = self._load_collection()
        
        # Create wallpaper entry
        wallpaper_entry = {
            "wallhaven_id": wallpaper_id,
            "resolution": resolution,
            "primary_colors": ["#000000"],  # Placeholder for now
            "file_extension": file_extension
        }
        
        # Add category if provided
        if category:
            wallpaper_entry["category"] = category
        
        collection["wallpapers"][wallpaper_id] = wallpaper_entry
        self._save_collection(collection)
    
    def remove_wallpaper(self, wallpaper_id: str) -> None:
        """Remove a wallpaper from the collection"""
        collection = self._load_collection()
        
        if wallpaper_id in collection["wallpapers"]:
            del collection["wallpapers"][wallpaper_id]
            self._save_collection(collection)
    
    def get_wallpaper_info(self, wallpaper_id: str) -> Optional[Dict]:
        """Get information about a specific wallpaper"""
        collection = self._load_collection()
        return collection["wallpapers"].get(wallpaper_id)
    
    def list_wallpapers(self) -> List[str]:
        """List all wallpaper IDs in the collection"""
        collection = self._load_collection()
        return list(collection["wallpapers"].keys())
    
    def get_missing_wallpapers(self) -> List[str]:
        """Get list of wallpaper IDs that are in collection but not on disk"""
        collection = self._load_collection()
        missing = []
        
        for wallpaper_id, info in collection["wallpapers"].items():
            file_extension = info.get("file_extension", ".jxl")
            wallpaper_file = self.config.saved_dir / f"{wallpaper_id}{file_extension}"
            
            if not wallpaper_file.exists():
                missing.append(wallpaper_id)
        
        return missing
    
    def get_untracked_wallpapers(self) -> List[Path]:
        """Get list of wallpaper files in saved directory not in collection"""
        collection = self._load_collection()
        tracked_ids = set(collection["wallpapers"].keys())
        untracked = []
        
        # Check for .jxl files in saved directory
        if self.config.saved_dir.exists():
            for wallpaper_file in self.config.saved_dir.glob("*.jxl"):
                wallpaper_id = wallpaper_file.stem
                if wallpaper_id not in tracked_ids:
                    untracked.append(wallpaper_file)
        
        return untracked