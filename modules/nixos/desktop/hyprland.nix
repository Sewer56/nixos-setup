{
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Hyprland Desktop from flake
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true; # Session management
  };

  # Strip cap_sys_nice from Hyprland wrapper.
  # The NixOS module sets cap_setpcap,cap_sys_nice=ep for real-time scheduling,
  # but this makes every Hyprland child inherit CAP_SYS_NICE in ambient set.
  # xdg-desktop-portal then can't open /proc/<child-pid>/root (kernel blocks
  # access when caller caps aren't subset of portal caps), breaking ALL portals
  # (FileChooser, Screenshot, etc). See flatpak/xdg-desktop-portal#1691.
  security.wrappers.Hyprland.capabilities = lib.mkForce "";

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
