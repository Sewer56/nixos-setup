{pkgs, ...}: {
  # Power management services
  services = {
    # Power profiles daemon for power management
    power-profiles-daemon.enable = true;

    # UPower for battery management
    upower.enable = true;
  };

  # Required packages for power management
  environment.systemPackages = with pkgs; [
    power-profiles-daemon
    upower
    powertop # Power consumption analysis tool
    acpi # ACPI utilities for laptop power management
  ];

  # Laptop-specific power optimization settings
  powerManagement = {
    enable = true;
  };

  # Additional laptop power optimizations
  boot.kernelParams = [
    # Enable power saving for SATA devices
    "ahci.mobile_lpm_policy=3"
  ];

  # TLP conflicts with power-profiles-daemon, so we don't enable it
  # services.tlp.enable = false;
}
