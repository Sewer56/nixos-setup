"""Color analysis module for extracting dominant colors from wallpapers."""

from pathlib import Path
from typing import List, Tuple
import colorsys
from PIL import Image
import numpy as np
from sklearn.cluster import KMeans

from ..converters.jxl import JXLConverter


def extract_dominant_colors(image_path: Path, num_colors: int = 10) -> List[Tuple[int, int, int]]:
    """
    Extract dominant colors from an image using k-means clustering.
    
    Args:
        image_path: Path to the image file
        num_colors: Number of dominant colors to extract
        
    Returns:
        List of RGB tuples representing dominant colors
    """
    # Handle JXL files by converting them first
    temp_file = None
    actual_image_path = image_path
    
    if image_path.suffix.lower() == '.jxl':
        success, converted_path = JXLConverter.convert_from_jxl(image_path)
        if success:
            actual_image_path = converted_path
            temp_file = converted_path
        else:
            raise ValueError(f"Failed to convert JXL file: {image_path}")
    
    try:
        # Load and prepare image
        img = Image.open(actual_image_path)
        
        # Convert to RGB if needed
        if img.mode != 'RGB':
            img = img.convert('RGB')
        
        # Resize for faster processing
        img.thumbnail((300, 300))
        
        # Convert to numpy array and reshape
        img_array = np.array(img)
        pixels = img_array.reshape(-1, 3)
        
        # Apply k-means clustering
        kmeans = KMeans(n_clusters=num_colors, random_state=42, n_init=10)
        kmeans.fit(pixels)
        
        # Get cluster centers (dominant colors)
        colors = kmeans.cluster_centers_.astype(int)
        
        # Get cluster sizes to sort by dominance
        labels = kmeans.labels_
        label_counts = np.bincount(labels)
        
        # Sort colors by frequency
        sorted_indices = np.argsort(-label_counts)
        sorted_colors = colors[sorted_indices]
        
        # Convert to tuples
        return [tuple(color) for color in sorted_colors]
        
    finally:
        # Clean up temporary file if it was created
        if temp_file:
            JXLConverter.cleanup_temp_file(temp_file)


def filter_background_colors(colors: List[Tuple[int, int, int]], threshold: float = 0.15) -> List[Tuple[int, int, int]]:
    """
    Filter out colors that are likely background (very dark, very light, or grayscale).
    
    Args:
        colors: List of RGB color tuples
        threshold: Brightness/saturation threshold for filtering
        
    Returns:
        Filtered list of RGB colors
    """
    filtered_colors = []
    
    for color in colors:
        # Convert to HSL
        r, g, b = [x / 255.0 for x in color]
        h, l, s = colorsys.rgb_to_hls(r, g, b)
        
        # Filter criteria:
        # - Not too dark (lightness > 15%)
        # - Not too light (lightness < 85%)
        # - Not grayscale (saturation > 10%)
        if 0.15 < l < 0.85 and s > 0.10:
            filtered_colors.append(color)
    
    return filtered_colors


def rgb_to_hex(rgb: Tuple[int, int, int]) -> str:
    """
    Convert RGB tuple to hex color string.
    
    Args:
        rgb: RGB color tuple (0-255 for each component)
        
    Returns:
        Hex color string (e.g., '#ff0000')
    """
    return '#{:02x}{:02x}{:02x}'.format(*rgb)