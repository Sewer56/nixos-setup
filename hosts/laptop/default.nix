# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Core System Stuff
    ../../modules/nixos/core/default.nix
    # Base Nvidia driver support.
    # PRIME Sync (Multi-GPU) is configured below in current file.
    ../../modules/nixos/hardware/graphics/nvidia.nix
    # Hyprland desktop
    ../../modules/nixos/desktop/default.nix
    # My user stuff
    ../../users/sewer/default.nix
  ];

  # Host-specific settings
  networking.hostName = "laptop"; # Define your hostname.

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Machine-specific Intel iGPU driver
  services.xserver.videoDrivers = [
    "modesetting" # Intel iGPU;
    "nvidia"
  ];

  # Machine-specific nvidia dual-GPU setup.
  # Ignore if not on Nvidia.
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    #sync.enable = true;
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:01:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
