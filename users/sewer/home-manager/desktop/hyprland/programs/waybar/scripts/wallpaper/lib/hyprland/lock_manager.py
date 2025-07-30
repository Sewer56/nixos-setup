#!/usr/bin/env python3

"""
Hyprpaper operation lock manager
Provides reusable file locking for preventing concurrent hyprpaper operations
"""

import fcntl
import sys
from contextlib import contextmanager
from typing import Generator

HYPRPAPER_LOCK_FILE = "/tmp/hyprpaper-operations.lock"

class HyprpaperLockError(Exception):
    """Exception raised when hyprpaper lock cannot be acquired"""
    pass

@contextmanager
def hyprpaper_lock(silent_exit: bool = False) -> Generator[None, None, None]:
    """Context manager for hyprpaper operation locking
    
    Args:
        silent_exit: If True, calls sys.exit(0) when lock is busy.
                    If False, raises HyprpaperLockError when lock is busy.
    
    Yields:
        None when lock is successfully acquired
        
    Raises:
        HyprpaperLockError: When lock cannot be acquired and silent_exit=False
        
    Example:
        # Script-level locking (silent exit when busy)
        with hyprpaper_lock(silent_exit=True):
            # Script logic here
            pass
            
        # Operation-level locking (exception when busy)  
        try:
            with hyprpaper_lock(silent_exit=False):
                # Hyprpaper operation here
                pass
        except HyprpaperLockError:
            # Handle busy lock
            pass
    """
    try:
        with open(HYPRPAPER_LOCK_FILE, 'w') as lockfile:
            # Try to acquire exclusive lock (non-blocking)
            # Errors if lock cannot be acquired
            fcntl.flock(lockfile.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            
            # Lock acquired - yield control to caller
            yield
            
            # Lock automatically released when file closes
            
    except BlockingIOError:
        # Another hyprpaper operation is in progress
        if silent_exit:
            # Script-level usage - exit silently
            sys.exit(0)
        else:
            # Operation-level usage - raise exception
            raise HyprpaperLockError("Another hyprpaper operation is in progress")