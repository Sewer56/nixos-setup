{
  pkgs,
  inputs,
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
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.default
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
    enable = true;
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
