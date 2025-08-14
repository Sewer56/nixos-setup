{pkgs, ...}: {
  # Hyprland Desktop
  programs.hyprland = {
    enable = true;
    withUWSM = true; # Session management
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
    xdgOpenUsePortal = true;
  };

  # Nicely ask programs to use Wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
