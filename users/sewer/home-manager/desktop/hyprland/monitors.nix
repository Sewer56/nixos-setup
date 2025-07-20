{
  pkgs,
  config,
  ...
}: {
  # Install nwg-displays for monitor configuration
  home.packages = with pkgs; [
    nwg-displays
  ];

  # Link monitors.conf from repo to make it mutable
  xdg.configFile."hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "./monitors.conf";

  # Source the monitors.conf file in Hyprland
  wayland.windowManager.hyprland.extraConfig = ''
    source = ~/.config/hypr/monitors.conf
  '';
}
