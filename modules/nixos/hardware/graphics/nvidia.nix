# NVIDIA GPU configuration
# This module configures NVIDIA graphics cards with Intel Prime offloading
# Reference: https://wiki.nixos.org/wiki/Nvidia
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Map driver version option to actual package
  driverPackages = {
    stable = config.boot.kernelPackages.nvidiaPackages.stable;
    beta = config.boot.kernelPackages.nvidiaPackages.beta;
    production = config.boot.kernelPackages.nvidiaPackages.production;
    vulkan_beta = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    legacy_470 = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    legacy_390 = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  };
  selectedDriver = config.hostOptions.hardware.nvidia.driverVersion;
in {
  imports = [
    ./common.nix
  ];

  # NVIDIA-specific packages
  environment.systemPackages = with pkgs; [
    nvitop
  ];

  # Early loading of NVIDIA kernel modules in initrd.
  # Without this, nvidia-drm registers late (28s+ after boot on some systems)
  # and fails to properly enumerate displays on warm boot:
  #   "Failed to get dynamic displays during device registration"
  #   "Cannot find any crtc or sizes"
  # This causes DP link training to fall back to 60Hz instead of 240Hz.
  # Gated by hostOptions — only desktop enables this (laptop ESP too small).
  boot.initrd.kernelModules = lib.mkIf config.hostOptions.hardware.nvidia.earlyLoading [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
  ];

  # Explicit kernel params — the NixOS nvidia module conditionally adds these
  # but only when services.xserver.enable=true for kernelModules. Force them
  # unconditionally since they've been observed missing from cmdline.
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  # NVIDIA VRR must be explicitly allowed via env vars on the open kernel module.
  # Without these, the driver won't expose VRR capability to Wayland compositors,
  # resulting in vrr: false even when misc:vrr is set in Hyprland.
  environment.sessionVariables = {
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Driver version is configurable per-host via hostOptions.hardware.nvidia.driverVersion
    package = driverPackages.${selectedDriver};
  };
}
