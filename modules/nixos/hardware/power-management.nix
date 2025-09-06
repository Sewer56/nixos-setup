{pkgs, ...}: {
  # Power management services
  services = {
    # TuneD for advanced power management with power-profiles-daemon compatibility
    tuned = {
      enable = true;
      ppdSupport = true; # Enable power-profiles-daemon API compatibility
    };

    # TLP conflicts with tuned, so it's disabled
    # tlp.enable = true;

    # Prevent overheating on Intel CPUs
    thermald.enable = true;

    # UPower for battery management
    upower.enable = true;
  };

  # Required packages for power management
  environment.systemPackages = with pkgs; [
    tuned
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

  # Systemd sleep hook to track resume timestamps for waybar uptime widget
  environment.etc."systemd/system-sleep/uptime-tracker" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      # Systemd sleep hook for tracking resume timestamps
      # Used by waybar uptime widget to show time since last resume

      TIMESTAMP_FILE="/tmp/last-resume"

      case "$1" in
        post)
          # Write timestamp on resume (post-suspend/hibernate)
          if [ "$2" = "suspend" ] || [ "$2" = "hibernate" ] || [ "$2" = "hybrid-sleep" ]; then
            echo "$(${pkgs.coreutils}/bin/date '+%s')" > "$TIMESTAMP_FILE"
            ${pkgs.coreutils}/bin/chmod 644 "$TIMESTAMP_FILE"
          fi
          ;;
      esac
    '';
    mode = "0755";
  };
}
