# Common graphics configuration for all GPU types
# This module provides shared settings that all graphics cards need
# Reference: https://wiki.nixos.org/wiki/Graphics
{...}: {
  # Enable hardware graphics acceleration
  hardware.graphics = {
    enable = true;
    # Enable 32-bit graphics support for Wine, Steam, and other 32-bit applications
    enable32Bit = true;
  };
}
