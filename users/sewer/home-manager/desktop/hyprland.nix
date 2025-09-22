{
  pkgs,
  inputs,
  lib,
  ...
}: {
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
    portalPackage = null; # Use the default portal package
    plugins = [
      pkgs.hyprlandPlugins.hypr-dynamic-cursors
      inputs.hyprWorkspaceLayouts.packages.${pkgs.system}.default
    ];
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    xwayland.enable = true;
  };

  # Must be synced with nixos module, due to home-manager bug that overrides.
  xdg.portal = {
    enable = lib.mkForce true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "gtk";
  };

  # Polkit agent for privilege escalation in text editors like vscode
  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland.settings = {
    debug.full_cm_proto = true;
    # unscale XWayland
    xwayland.force_zero_scaling = true;
  };
}
