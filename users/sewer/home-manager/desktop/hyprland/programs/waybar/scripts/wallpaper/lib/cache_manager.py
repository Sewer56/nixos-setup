#!/usr/bin/env python3

"""
Cache management for Wallhaven API responses
"""

import json
import hashlib
import time
from pathlib import Path
from typing import Any, Optional, List
from datetime import datetime, timedelta


class CacheManager:
    """Manages cached API responses with expiration"""
    
    def __init__(self, cache_dir: Optional[Path] = None):
        """Initialize cache manager
        
        Args:
            cache_dir: Directory to store cache files. 
                      Defaults to ~/.cache/wallhaven
        """
        if cache_dir is None:
            cache_dir = Path.home() / ".cache" / "wallhaven"
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
    
    def _generate_hash(self, *args) -> str:
        """Generate consistent hash from arguments
        
        Args:
            *args: Arguments to hash
            
        Returns:
            SHA256 hash hex string
        """
        # Convert all arguments to strings and join
        combined = '|'.join(str(arg) for arg in args)
        return hashlib.sha256(combined.encode()).hexdigest()
    
    def _get_cache_file(self, key: str) -> Path:
        """Get path to cache file for given key
        
        Args:
            key: Cache key
            
        Returns:
            Path to cache file
        """
        return self.cache_dir / f"{key}.json"
    
    def get(self, key: str, max_age_days: int = 7) -> Optional[Any]:
        """Get cached data if it exists and is not expired
        
        Args:
            key: Cache key
            max_age_days: Maximum age of cache in days
            
        Returns:
            Cached data or None if not found/expired
        """
        cache_file = self._get_cache_file(key)
        
        if not cache_file.exists():
            return None
        
        try:
            with open(cache_file, 'r') as f:
                cache_data = json.load(f)
            
            # Check if cache is expired
            cached_time = datetime.fromisoformat(cache_data['timestamp'])
            max_age = timedelta(days=max_age_days)
            
            if datetime.now() - cached_time > max_age:
                # Cache expired, remove it
                cache_file.unlink()
                return None
            
            return cache_data['data']
            
        except (json.JSONDecodeError, KeyError, ValueError):
            # Invalid cache file, remove it
            cache_file.unlink()
            return None
    
    def set(self, key: str, data: Any) -> None:
        """Store data in cache
        
        Args:
            key: Cache key
            data: Data to cache
        """
        cache_file = self._get_cache_file(key)
        
        cache_data = {
            'timestamp': datetime.now().isoformat(),
            'data': data
        }
        
        with open(cache_file, 'w') as f:
            json.dump(cache_data, f, indent=2)
    
    def clear(self, max_age_days: Optional[int] = None) -> int:
        """Clear expired cache entries
        
        Args:
            max_age_days: Clear entries older than this. 
                         If None, clears all entries.
                         
        Returns:
            Number of entries cleared
        """
        cleared = 0
        
        for cache_file in self.cache_dir.glob('*.json'):
            if max_age_days is None:
                cache_file.unlink()
                cleared += 1
            else:
                try:
                    with open(cache_file, 'r') as f:
                        cache_data = json.load(f)
                    
                    cached_time = datetime.fromisoformat(cache_data['timestamp'])
                    max_age = timedelta(days=max_age_days)
                    
                    if datetime.now() - cached_time > max_age:
                        cache_file.unlink()
                        cleared += 1
                        
                except (json.JSONDecodeError, KeyError, ValueError):
                    # Invalid cache file, remove it
                    cache_file.unlink()
                    cleared += 1
        
        return cleared
    
    def generate_search_key(self, **search_params) -> str:
        """Generate cache key for search parameters
        
        Args:
            **search_params: Search parameters
            
        Returns:
            Cache key string
        """
        # Sort parameters for consistent hashing
        sorted_params = sorted(search_params.items())
        return self._generate_hash(*sorted_params)