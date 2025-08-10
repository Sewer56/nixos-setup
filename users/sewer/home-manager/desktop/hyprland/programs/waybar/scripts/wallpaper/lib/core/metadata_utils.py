#!/usr/bin/env python3

"""
Metadata utilities for wallpaper sidecar files
"""

import json
from pathlib import Path
from typing import Dict, Any, Optional


def save_wallpaper_metadata(wallpaper_path: Path, metadata: Dict[str, Any]) -> bool:
    """Save wallpaper metadata to sidecar file
    
    Args:
        wallpaper_path: Path to the wallpaper image file
        metadata: Dictionary containing wallpaper metadata from API
        
    Returns:
        True if metadata was saved successfully, False otherwise
    """
    try:
        # Create metadata file path by replacing extension with .meta.json
        metadata_path = wallpaper_path.with_suffix('.meta.json')
        
        # Ensure directory exists
        metadata_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Save metadata as JSON
        with open(metadata_path, 'w') as f:
            json.dump(metadata, f, indent=2, sort_keys=True)
        
        return True
        
    except Exception:
        return False


def load_wallpaper_metadata(wallpaper_path: Path) -> Optional[Dict[str, Any]]:
    """Load wallpaper metadata from sidecar file
    
    Args:
        wallpaper_path: Path to the wallpaper image file
        
    Returns:
        Dictionary containing metadata, or None if not found/invalid
    """
    try:
        # Create metadata file path by replacing extension with .meta.json
        metadata_path = wallpaper_path.with_suffix('.meta.json')
        
        # Check if metadata file exists
        if not metadata_path.exists():
            return None
            
        # Load metadata from JSON
        with open(metadata_path, 'r') as f:
            metadata = json.load(f)
            
        # Basic validation - ensure it's a dictionary
        if not isinstance(metadata, dict):
            return None
            
        return metadata
        
    except Exception:
        return None


def get_wallpaper_display_info(wallpaper_path: Path, collection_manager=None) -> Dict[str, str]:
    """Get display information for wallpaper notification
    
    Args:
        wallpaper_path: Path to wallpaper file
        collection_manager: Optional collection manager for fallback data
        
    Returns:
        Dictionary with 'name', 'resolution', and 'category' keys
    """
    # Get wallpaper name without extension
    name = wallpaper_path.stem
    
    # Try to load metadata from sidecar file first
    metadata = load_wallpaper_metadata(wallpaper_path)
    
    if metadata:
        # Use metadata from sidecar file
        resolution = metadata.get('resolution', '')
        category = metadata.get('category', '')
    elif collection_manager:
        # Fallback to collection manager
        wallpaper_info = collection_manager.get_wallpaper_info(name)
        if wallpaper_info:
            resolution = wallpaper_info.get('resolution', '')
            category = wallpaper_info.get('category', '')  # Will be empty for existing entries
        else:
            resolution = ''
            category = ''
    else:
        # No metadata available
        resolution = ''
        category = ''
    
    return {
        'name': name,
        'resolution': resolution,
        'category': category
    }


def cleanup_wallpaper_metadata(wallpaper_path: Path) -> bool:
    """Remove metadata sidecar file when wallpaper is deleted
    
    Args:
        wallpaper_path: Path to the wallpaper image file
        
    Returns:
        True if metadata file was removed or didn't exist, False on error
    """
    try:
        metadata_path = wallpaper_path.with_suffix('.meta.json')
        
        if metadata_path.exists():
            metadata_path.unlink()
        
        return True
        
    except Exception:
        return False