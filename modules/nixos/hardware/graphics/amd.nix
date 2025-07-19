# AMD GPU configuration
# UNTESTED - Based on NixOS wiki research and current best practices
# Reference: https://wiki.nixos.org/wiki/AMD_GPU
{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  # AMD-specific graphics packages for compute and monitoring
  hardware.graphics.extraPackages = with pkgs; [
    # ROCm OpenCL runtime for compute workloads
    rocmPackages.clr.icd
  ];

  # Kernel parameters for older AMD GPUs (Southern Islands and Sea Islands)
  # Uncomment if using GCN 1 or GCN 2 hardware:
  # boot.kernelParams = [
  #   "radeon.si_support=0"
  #   "amdgpu.si_support=1"    # For GCN 1
  #   "radeon.cik_support=0"
  #   "amdgpu.cik_support=1"   # For GCN 2
  # ];

  # AMD-specific packages for monitoring and utilities
  environment.systemPackages = with pkgs; [
    # AMD GPU monitoring tool
    radeontop
  ];

  # Optional: Environment variables for specific use cases
  # environment.variables = {
  #   # Force RADV driver (usually not needed as it's default)
  #   AMD_VULKAN_ICD = "RADV";
  #   # VDPAU driver for video acceleration
  #   VDPAU_DRIVER = "radeonsi";
  # };
}
