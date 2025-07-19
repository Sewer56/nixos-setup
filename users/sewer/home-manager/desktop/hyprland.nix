{...}: {
  imports = [
    ./hyprland/default.nix
  ];

  # Hyprland Window Manager (User Configuration)
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    xwayland.enable = true;
  };

  # Polkit agent for privilege escalation in text editors like vscode
  services.hyprpolkitagent.enable = true;
}
