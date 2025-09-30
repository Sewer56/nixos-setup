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
  # Spotify ports: 4070 (Spotify Connect), 443 (HTTPS API), 5353 (discovery protocol)
  networking.firewall.allowedTCPPorts = [4070 443];
  networking.firewall.allowedUDPPorts = [5353];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
