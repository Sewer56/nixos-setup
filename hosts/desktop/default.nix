# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    # nixos-generate-config --root /mnt
    ./hardware-configuration.nix
    # Core System Stuff
    ../../modules/nixos/core/default.nix
    # Base Nvidia driver support.
    ../../modules/nixos/hardware/graphics/nvidia.nix
    # Bluetooth support (laptop-specific)
    ../../modules/nixos/hardware/bluetooth.nix
    # Hyprland desktop
    ../../modules/nixos/desktop/default.nix
    # My user stuff
    ../../users/sewer/default.nix
  ];

  # Host-specific settings
  networking.hostName = "desktop"; # Define your hostname.

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Swapfile sized for desktop use (64GB)
  swapDevices = [
    {
      device = "/swapfile";
      size = 65536;
    }
  ];

  # Machine-specific Nvidia driver only (desktop typically has dedicated GPU)
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}