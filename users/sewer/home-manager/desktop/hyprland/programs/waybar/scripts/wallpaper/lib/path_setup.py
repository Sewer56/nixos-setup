#!/usr/bin/env python3

"""Setup Python path for wallpaper scripts"""

import sys
from pathlib import Path


def setup_lib_path():
    """Add lib directory to Python path"""
    # Get the lib directory (this file is in lib/)
    lib_dir = Path(__file__).parent
    script_dir = lib_dir.parent
    
    # Add to path if not already there
    paths_to_add = [str(script_dir), str(lib_dir)]
    for path in paths_to_add:
        if path not in sys.path:
            sys.path.insert(0, path)