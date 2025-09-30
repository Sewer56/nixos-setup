#!/usr/bin/env python3

"""
Set a random wallpaper matching the current accent color
"""

import sys
import subprocess
import os
from pathlib import Path
from typing import List, Optional
import random

# Setup library path
sys.path.insert(0, str(Path(__file__).parent))
from lib.path_setup import setup_lib_path
setup_lib_path()

# Now import from organized modules
from lib.core.notifications import notify_info, notify_error, notify_warning, notify_success
from lib.hyprland.lock_manager import hyprpaper_lock
from lib.services.wallpaper_manager import WallpaperManager
from lib.services.color_analyzer import extract_dominant_colors, filter_background_colors, rgb_to_hex
from lib.services.color_matcher import load_accent_colors, find_best_matching_accent
from lib.services.nix_config_updater import update_theme_accent, get_current_accent


def get_wallpaper_colors(wallpaper_path: Path, cache_dir: Path) -> List[str]:
    """
    Get dominant colors from a wallpaper, using cache if available.
    
    Args:
        wallpaper_path: Path to wallpaper image
        cache_dir: Directory for color cache
        
    Returns:
        List of hex color strings
    """
    # Create cache directory if needed
    cache_dir.mkdir(parents=True, exist_ok=True)
    
    # Cache file based on wallpaper path and modification time
    cache_key = f"{wallpaper_path.stem}_{wallpaper_path.stat().st_mtime:.0f}.json"
    cache_file = cache_dir / cache_key
    
    # Check cache
    if cache_file.exists():
        try:
            import json
            with open(cache_file, 'r') as f:
                return json.load(f)
        except Exception:
            pass
    
    # Extract colors
    try:
        rgb_colors = extract_dominant_colors(wallpaper_path, num_colors=15)
        filtered_colors = filter_background_colors(rgb_colors)
        hex_colors = [rgb_to_hex(color) for color in filtered_colors]
        
        # Save to cache
        import json
        with open(cache_file, 'w') as f:
            json.dump(hex_colors, f)
        
        # Clean old cache files for this wallpaper
        for old_cache in cache_dir.glob(f"{wallpaper_path.stem}_*.json"):
            if old_cache != cache_file:
                old_cache.unlink()
        
        return hex_colors
    except Exception as e:
        notify_error(f"Error extracting colors from {wallpaper_path}: {e}")
        return []


def rebuild_nixos_config() -> bool:
    """
    Rebuild NixOS configuration and manually trigger startup-wrapper.
    
    Returns:
        True if successful, False otherwise
    """
    try:
        # Run nixos-rebuild
        result = subprocess.run([
            'sudo', 'nixos-rebuild', 'test', '--flake', '/home/sewer/nixos'
        ], capture_output=True, text=True, timeout=240)
        
        if result.returncode == 0:
            # Manually trigger wallpaper restoration since nixos-rebuild doesn't trigger 
            # Hyprland exec commands when ran here for some reason.
            try:
                # Call startup-wrapper.py with --no-lock to skip lock conflicts
                wrapper_path = Path(__file__).parent / 'startup-wrapper.py'
                result = subprocess.run([str(wrapper_path), '--no-lock'], timeout=30, check=False)
                return True
            except Exception as wrapper_error:
                notify_warning(f"Failed to run startup-wrapper: {wrapper_error}")
                # Don't fail the whole operation if wrapper fails
                return True
        else:
            notify_error(f"nixos-rebuild failed: {result.stderr}")
            return False
            
    except subprocess.TimeoutExpired:
        notify_error("nixos-rebuild timed out")
        return False
    except Exception as e:
        notify_error(f"Error running nixos-rebuild: {e}")
        return False


def main():
    """Main function to analyze current wallpaper and update accent color"""
    # Prevent concurrent execution using file locking
    with hyprpaper_lock(silent_exit=True):
        try:
            # Show initial notification
            notify_info("Analyzing wallpaper colors...")
            
            # Get current wallpaper
            wallpaper_manager = WallpaperManager()
            monitors = wallpaper_manager.get_current_wallpapers()
            
            if not monitors:
                notify_error("No wallpapers found")
                sys.exit(1)
            
            # Use first monitor's wallpaper
            current_wallpaper = Path(list(monitors.values())[0])
            
            if not current_wallpaper.exists():
                notify_error(f"Wallpaper not found: {current_wallpaper}")
                sys.exit(1)
            
            # Get wallpaper colors
            cache_dir = Path.home() / '.cache' / 'waybar-wallpaper-colors'
            wallpaper_colors = get_wallpaper_colors(current_wallpaper, cache_dir)
            
            if not wallpaper_colors:
                # TODO: improve this error
                notify_warning("No suitable colors found in wallpaper")
                sys.exit(1)
            
            # Load accent colors and find best match
            accent_colors = load_accent_colors()
            best_accent, confidence = find_best_matching_accent(wallpaper_colors, accent_colors)
            
            # Get current accent
            current_accent = get_current_accent()
            
            if current_accent == best_accent:
                notify_info(f"Accent already set to {best_accent}")
                sys.exit(0)
            
            # Show confidence warning if low
            if confidence < 0.3:
                notify_warning(f"Low confidence match: {best_accent} ({confidence:.0%})")
            else:
                notify_info(f"Best match: {best_accent} ({confidence:.0%})")
            
            # Update theme.nix
            if not update_theme_accent(best_accent):
                notify_error("Failed to update theme.nix")
                sys.exit(1)
            
            # Rebuild NixOS configuration
            notify_info("Rebuilding NixOS configuration...")
            
            if rebuild_nixos_config():
                notify_success(f"Accent changed to {best_accent}")
            else:
                notify_error("Failed to rebuild NixOS configuration")
                # Revert the change
                if current_accent:
                    update_theme_accent(current_accent)
                sys.exit(1)
                
        except Exception as e:
            notify_error(f"Error: {str(e)}")
            sys.exit(1)


if __name__ == "__main__":
    main()