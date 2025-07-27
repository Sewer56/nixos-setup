#!/usr/bin/env python3

"""
Wallhaven API client for interacting with wallhaven.cc API
"""

import json
import time
from typing import Dict, Optional, Any
from urllib.request import urlopen, Request
from urllib.parse import urlencode
from urllib.error import HTTPError

from ..constants import USER_AGENT, WALLHAVEN_RATE_LIMIT, WALLHAVEN_RATE_LIMIT_WINDOW


class WallhavenClient:
    """Client for Wallhaven API with rate limiting support"""
    
    BASE_URL = "https://wallhaven.cc/api/v1"
    RATE_LIMIT = WALLHAVEN_RATE_LIMIT  # calls per minute
    RATE_LIMIT_WINDOW = WALLHAVEN_RATE_LIMIT_WINDOW  # seconds
    
    def __init__(self, api_key: Optional[str] = None):
        """Initialize Wallhaven API client
        
        Args:
            api_key: Optional API key for authenticated requests
        """
        self.api_key = api_key
        self.request_times = []
    
    def _rate_limit_wait(self) -> None:
        """Implement rate limiting to respect API limits"""
        now = time.time()
        
        # Remove requests older than rate limit window
        self.request_times = [t for t in self.request_times 
                            if now - t < self.RATE_LIMIT_WINDOW]
        
        # If we've hit the rate limit, wait
        if len(self.request_times) >= self.RATE_LIMIT:
            # Calculate how long to wait
            oldest_request = self.request_times[0]
            wait_time = self.RATE_LIMIT_WINDOW - (now - oldest_request) + 0.1
            if wait_time > 0:
                time.sleep(wait_time)
        
        # Record this request
        self.request_times.append(time.time())
    
    def _make_request(self, endpoint: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Make HTTP request to API endpoint
        
        Args:
            endpoint: API endpoint path
            params: Query parameters
            
        Returns:
            JSON response as dictionary
            
        Raises:
            URLError: On network errors
            HTTPError: On HTTP errors
        """
        self._rate_limit_wait()
        
        if params is None:
            params = {}
        
        # Add API key if available
        if self.api_key:
            params['apikey'] = self.api_key
        
        # Build URL
        url = f"{self.BASE_URL}{endpoint}"
        if params:
            url = f"{url}?{urlencode(params)}"
        
        # Make request
        request = Request(url, headers={'User-Agent': USER_AGENT})
        
        try:
            with urlopen(request, timeout=30) as response:
                return json.loads(response.read().decode())
        except HTTPError as e:
            if e.code == 429:  # Rate limit exceeded
                # Wait and retry once
                time.sleep(60)
                with urlopen(request, timeout=30) as response:
                    return json.loads(response.read().decode())
            raise
    
    def search(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """Search for wallpapers
        
        Args:
            params: Search parameters including:
                - q: Search query
                - categories: Category filter (e.g., '110' for general+anime)
                - purity: Purity filter (e.g., '100' for SFW only)
                - sorting: Sort method
                - order: Sort order
                - atleast: Minimum resolution
                - page: Page number
                
        Returns:
            Search results with wallpaper data
        """
        return self._make_request('/search', params)
    
    def get_wallpaper(self, wallpaper_id: str) -> Dict[str, Any]:
        """Get details for a specific wallpaper
        
        Args:
            wallpaper_id: Wallpaper ID
            
        Returns:
            Wallpaper details
        """
        return self._make_request(f'/w/{wallpaper_id}')
    
    def get_collection(self, username: str, collection_id: str, 
                      params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Get wallpapers from a user's collection
        
        Args:
            username: Username of collection owner
            collection_id: Collection ID
            params: Optional query parameters (e.g., page)
            
        Returns:
            Collection wallpapers
        """
        endpoint = f'/collections/{username}/{collection_id}'
        return self._make_request(endpoint, params)
    
    def get_user_collections(self, username: str) -> Dict[str, Any]:
        """Get list of user's collections
        
        Args:
            username: Username
            
        Returns:
            User's collections
        """
        return self._make_request(f'/collections/{username}')