{pkgs, ...}: {
  imports = [
    ./hyprland/default.nix
  ];

  # Enable Wayland support for Chrome/Chromium-based applications
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Hyprland Window Manager (User Configuration)
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprtrails
      hypr-dynamic-cursors
    ];
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    xwayland.enable = true;
  };

  # Polkit agent for privilege escalation in text editors like vscode
  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland.settings = {
    debug.full_cm_proto = true;
    # unscale XWayland
    xwayland.force_zero_scaling = true;
  };
}
