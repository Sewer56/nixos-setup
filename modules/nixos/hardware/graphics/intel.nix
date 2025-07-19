# Intel GPU configuration
# UNTESTED - Based on NixOS wiki research
# This module configures Intel integrated graphics with appropriate media drivers
# Reference: https://wiki.nixos.org/wiki/Intel_Graphics
{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  # Intel graphics hardware acceleration packages
  hardware.graphics.extraPackages = with pkgs; [
    # Modern Intel media driver for Broadwell (2014) and newer
    intel-media-driver
    # Legacy Intel VAAPI driver for older hardware
    intel-vaapi-driver
    # Intel GPU compute runtime
    intel-compute-runtime
  ];

  # Kernel parameters for specific Intel generations
  # Uncomment for 12th gen (Alder Lake) and newer if experiencing issues:
  # boot.kernelParams = [
  #   "i915.force_probe=*"
  # ];

  # Intel-specific packages for monitoring and utilities
  environment.systemPackages = with pkgs; [
    # Intel GPU monitoring
    intel-gpu-tools
    # Mesa utilities are included in common.nix
  ];
}
