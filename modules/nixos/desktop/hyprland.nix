{
  pkgs,
  lib,
  ...
}: {
  # Hyprland Desktop
  programs.hyprland = {
    enable = true;
    withUWSM = true; # Session management
    xwayland.enable = true;
  };

  # Must be synced with home-manager module, due to home-manager bug that overrides.
  xdg.portal = {
    enable = lib.mkForce true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "gtk";
  };

  # Nicely ask programs to use Wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
