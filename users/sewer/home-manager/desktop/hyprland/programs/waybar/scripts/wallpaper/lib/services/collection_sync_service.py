#!/usr/bin/env python3

"""
Collection sync service for downloading missing wallpapers and managing collection
"""

from pathlib import Path
from typing import List, Dict, Optional

from ..core.collection_manager import CollectionManager
from ..core.results import SyncResult
from ..core.file_utils import get_image_resolution
from ..converters.jxl import JXLConverter
from ..wallhaven.client import WallhavenClient
from ..wallhaven.downloader import WallpaperDownloader
from ..config import WallpaperConfig

class CollectionSyncService:
    """Service for syncing wallpaper collection"""
    
    def __init__(self, config: Optional[WallpaperConfig] = None):
        if config is None:
            config = WallpaperConfig()
        self.config = config
        self.collection_manager = CollectionManager(config)
        self.client = WallhavenClient()
        self.downloader = WallpaperDownloader(config)
    
    def sync_missing_wallpapers(self) -> SyncResult:
        """Download missing wallpapers from collection"""
        result = SyncResult(success=True)
        
        try:
            # Get list of missing wallpapers
            missing_wallpapers = self.collection_manager.get_missing_wallpapers()
            
            if not missing_wallpapers:
                return result
            
            # Download each missing wallpaper
            for wallpaper_id in missing_wallpapers:
                try:
                    # Get wallpaper data from Wallhaven API
                    api_response = self.client.get_wallpaper(wallpaper_id)
                    wallpaper_data = api_response.get('data', {})
                    
                    if not wallpaper_data:
                        result.failed_count += 1
                        result.errors.append(f"No data found for wallpaper {wallpaper_id}")
                        continue
                    
                    # Download to temp directory first
                    download_result = self.downloader.download_wallpaper(
                        wallpaper_data, 
                        target_dir=self.config.download_temp_dir
                    )
                    
                    if download_result.success and download_result.file_path:
                        # Convert to JXL and move to saved directory
                        jxl_path = self.config.saved_dir / f"{wallpaper_id}.jxl"
                        
                        if download_result.file_path.suffix.lower() == '.jxl':
                            # Already JXL, just move it
                            jxl_path.parent.mkdir(parents=True, exist_ok=True)
                            download_result.file_path.rename(jxl_path)
                            result.downloaded_count += 1
                        else:
                            # Convert to JXL
                            conversion_result = JXLConverter.convert_to_jxl(
                                download_result.file_path,
                                jxl_path,
                                remove_source=True
                            )
                            
                            if conversion_result.success:
                                result.downloaded_count += 1
                            else:
                                result.failed_count += 1
                                result.errors.append(f"Failed to convert {wallpaper_id} to JXL: {conversion_result.error_message}")
                    else:
                        result.failed_count += 1
                        result.errors.append(f"Failed to download {wallpaper_id}: {download_result.error_message}")
                        
                except Exception as e:
                    result.failed_count += 1
                    result.errors.append(f"Error downloading {wallpaper_id}: {str(e)}")
            
            # Set overall success based on whether we had any successes
            result.success = result.downloaded_count > 0 or result.failed_count == 0
            
        except Exception as e:
            result.success = False
            result.errors.append(f"Sync operation failed: {str(e)}")
        
        return result
    
    def update_collection_from_disk(self) -> Dict[str, int]:
        """Scan saved directory and add untracked wallpapers to collection"""
        stats = {"added": 0, "errors": 0}
        
        try:
            # Get untracked wallpapers
            untracked_wallpapers = self.collection_manager.get_untracked_wallpapers()
            
            for wallpaper_file in untracked_wallpapers:
                try:
                    # Extract wallpaper ID from filename
                    wallpaper_id = wallpaper_file.stem
                    
                    # Try to get resolution from the actual image file first
                    resolution = get_image_resolution(wallpaper_file)
                    
                    # If that fails, try to get metadata from Wallhaven API
                    if not resolution:
                        try:
                            api_response = self.client.get_wallpaper(wallpaper_id)
                            wallpaper_data = api_response.get('data', {})
                            resolution = wallpaper_data.get('resolution', 'unknown')
                        except Exception:
                            # Fall back to unknown if both methods fail
                            resolution = 'unknown'
                    
                    # Get file extension
                    file_extension = wallpaper_file.suffix
                    
                    # Add to collection
                    self.collection_manager.add_wallpaper(
                        wallpaper_id=wallpaper_id,
                        resolution=resolution,
                        file_extension=file_extension
                    )
                    
                    stats["added"] += 1
                    
                except Exception as e:
                    stats["errors"] += 1
                    
        except Exception:
            stats["errors"] += 1
        
        return stats
    
    def cleanup_orphaned_files(self) -> List[Path]:
        """Remove wallpaper files not in collection"""
        deleted_files = []
        
        try:
            # Get untracked wallpapers
            untracked_wallpapers = self.collection_manager.get_untracked_wallpapers()
            
            # Delete each file
            for wallpaper_file in untracked_wallpapers:
                try:
                    wallpaper_file.unlink()
                    deleted_files.append(wallpaper_file)
                except Exception:
                    # Skip files that can't be deleted
                    pass
                    
        except Exception:
            # Handle any errors silently for cleanup operations
            pass
        
        return deleted_files