# NVIDIA GPU configuration
# This module configures NVIDIA graphics cards with Intel Prime offloading
# Reference: https://wiki.nixos.org/wiki/Nvidia
{
  config,
  pkgs,
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
    powerManagement.enable = false;

    # Driver version is configurable per-host via hostOptions.hardware.nvidia.driverVersion
    package = driverPackages.${selectedDriver};
  };
}
