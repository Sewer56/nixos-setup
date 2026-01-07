{
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Hyprland Desktop from flake
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    withUWSM = true; # Session management
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
