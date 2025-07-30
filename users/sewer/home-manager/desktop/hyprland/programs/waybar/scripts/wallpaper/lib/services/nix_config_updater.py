"""Nix configuration update module for changing theme accent colors."""

import re
import shutil
from pathlib import Path
from typing import Optional


def update_theme_accent(new_accent: str) -> bool:
    """
    Update the accent color in the theme.nix configuration file.
    
    Args:
        new_accent: Name of the new accent color
        
    Returns:
        True if successful, False otherwise
    """
    theme_path = Path('/etc/nixos/users/sewer/home-manager/theme.nix')
    
    if not theme_path.exists():
        return False
    
    try:
        # Read the current content
        content = theme_path.read_text()
        
        # Pattern to match accent = "...";
        pattern = r'(accent\s*=\s*")[^"]+(";\s*)'
        
        # Check if pattern exists
        if not re.search(pattern, content):
            return False
        
        # Replace with new accent
        new_content = re.sub(pattern, rf'\1{new_accent}\2', content)
        
        # Write to temporary file first (atomic write)
        temp_path = theme_path.with_suffix('.tmp')
        temp_path.write_text(new_content)
        
        # Move temp file to actual file
        shutil.move(str(temp_path), str(theme_path))
        
        return True
        
    except Exception:
        # Clean up temp file if it exists
        temp_path = theme_path.with_suffix('.tmp')
        if temp_path.exists():
            temp_path.unlink()
        return False


def get_current_accent() -> Optional[str]:
    """
    Get the current accent color from theme.nix.
    
    Returns:
        Current accent color name or None if not found
    """
    theme_path = Path('/etc/nixos/users/sewer/home-manager/theme.nix')
    
    if not theme_path.exists():
        return None
    
    try:
        content = theme_path.read_text()
        
        # Pattern to match accent = "...";
        pattern = r'accent\s*=\s*"([^"]+)";'
        match = re.search(pattern, content)
        
        if match:
            return match.group(1)
        
        return None
        
    except Exception:
        return None


def create_sudoers_rule() -> str:
    """
    Generate sudoers rule content for passwordless nixos-rebuild.
    
    Returns:
        Path where rule should be placed
    """
    # This function returns the content and path for documentation
    # The actual rule will be added to security.nix
    return "/etc/sudoers.d/nixos-rebuild-waybar"