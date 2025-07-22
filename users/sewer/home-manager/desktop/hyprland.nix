{...}: {
  imports = [
    ./hyprland/default.nix
  ];

  # Enable Wayland support for Chrome/Chromium-based applications
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Hyprland Window Manager (User Configuration)
  xdg.autostart.enable = false;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = false;
    };
    xwayland.enable = true;
  };

  # Polkit agent for privilege escalation in text editors like vscode
  services.hyprpolkitagent.enable = true;
}
