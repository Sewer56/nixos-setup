{ pkgs, ... }: {
  # Hyprland Desktop
  programs.hyprland = {
    enable = true;
    withUWSM = true; # Session management
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
  };

  # Login Screen / SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };

  # Tell Electron and Chromium stuff to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}