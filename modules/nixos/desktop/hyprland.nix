{
  pkgs,
  inputs,
  ...
}: {
  # Hyprland Desktop
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true; # Session management
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    xdgOpenUsePortal = true;
  };

  # Nicely ask programs to use Wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
