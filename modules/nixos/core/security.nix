{...}: {
  # Add polkit for privilege escalation when needed by some programs
  security.polkit.enable = true;

  # Enable pcscd service for smart card support (YubiKey, etc.)
  services.pcscd.enable = true;

  # Sudoers rule for passwordless nixos-rebuild test (used by waybar wallpaper script)
  security.sudo.extraRules = [
    {
      users = ["sewer"];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild test";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
