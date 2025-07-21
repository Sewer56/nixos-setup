{pkgs, ...}: {
  # Network management GUI for system tray
  home.packages = with pkgs; [
    networkmanagerapplet # NetworkManager system tray applet
  ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # Start NetworkManager applet in system tray
      "nm-applet --indicator"
    ];
  };
}
