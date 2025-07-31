"""Color matching module for finding the best Catppuccin accent color match."""

import json
from pathlib import Path
from typing import Dict, List, Tuple
from colormath.color_objects import sRGBColor, LabColor
from colormath.color_conversions import convert_color
from colormath.color_diff import delta_e_cie2000


def load_accent_colors() -> Dict[str, str]:
    """
    Load accent colors from the theme configuration file.
    
    Returns:
        Dictionary mapping accent name to hex color
    """
    accent_colors_path = Path.home() / '.config' / 'theme' / 'accent-colors.json'
    
    if not accent_colors_path.exists():
        # Fallback to default Catppuccin accent colors
        return {
            "rosewater": "#f5e0dc",
            "flamingo": "#f2cdcd",
            "pink": "#f5c2e7",
            "mauve": "#cba6f7",
            "red": "#f38ba8",
            "maroon": "#eba0ac",
            "peach": "#fab387",
            "yellow": "#f9e2af",
            "green": "#a6e3a1",
            "teal": "#94e2d5",
            "sky": "#89dceb",
            "sapphire": "#74c7ec",
            "blue": "#89b4fa",
            "lavender": "#b4befe"
        }
    
    with open(accent_colors_path, 'r') as f:
        data = json.load(f)
        # Handle nested structure with 'colors' field
        if 'colors' in data and isinstance(data['colors'], dict):
            return data['colors']
        # Fallback to direct dictionary structure
        return data


def hex_to_lab(hex_color: str) -> LabColor:
    """
    Convert hex color to LAB color space.
    
    Args:
        hex_color: Hex color string (e.g., '#ff0000')
        
    Returns:
        LabColor object
    """
    # Remove # if present
    hex_color = hex_color.lstrip('#')
    
    # Convert hex to RGB
    r = int(hex_color[0:2], 16) / 255.0
    g = int(hex_color[2:4], 16) / 255.0
    b = int(hex_color[4:6], 16) / 255.0
    
    # Create sRGB color object
    rgb_color = sRGBColor(r, g, b)
    
    # Convert to LAB
    return convert_color(rgb_color, LabColor)


def calculate_color_distance(color1: str, color2: str) -> float:
    """
    Calculate perceptual distance between two colors using Delta E (CIE2000).
    
    Args:
        color1: First hex color string
        color2: Second hex color string
        
    Returns:
        Color distance (lower = more similar)
    """
    lab1 = hex_to_lab(color1)
    lab2 = hex_to_lab(color2)
    
    return delta_e_cie2000(lab1, lab2)


def find_best_matching_accent(wallpaper_colors: List[str], accent_colors: Dict[str, str]) -> Tuple[str, float]:
    """
    Find the best matching accent color for the given wallpaper colors.
    
    Args:
        wallpaper_colors: List of hex colors from the wallpaper
        accent_colors: Dictionary of accent name to hex color
        
    Returns:
        Tuple of (accent_name, confidence_score)
        Confidence score is 0-1, where 1 is perfect match
    """
    if not wallpaper_colors:
        # Default to blue if no colors found
        return ("blue", 0.0)
    
    best_accent = None
    best_distance = float('inf')
    
    # For each accent color, find the minimum distance to any wallpaper color
    for accent_name, accent_hex in accent_colors.items():
        min_distance = float('inf')
        
        for wp_color in wallpaper_colors:
            distance = calculate_color_distance(wp_color, accent_hex)
            min_distance = min(min_distance, distance)
        
        if min_distance < best_distance:
            best_distance = min_distance
            best_accent = accent_name
    
    # Convert distance to confidence score (0-1)
    # Delta E values: 0-1 imperceptible, 1-2 barely perceptible, 2-10 perceptible, 10-49 more obvious
    # Map distance to confidence: 0->1.0, 10->0.5, 50->0.0
    if best_distance <= 0:
        confidence = 1.0
    elif best_distance >= 50:
        confidence = 0.0
    else:
        confidence = 1.0 - (best_distance / 50.0)
    
    return (best_accent, confidence)