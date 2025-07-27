{...}: {
  services.hyprpaper.enable = true;

  # Set random wallpaper at login and sync collection in background
  wayland.windowManager.hyprland.settings.exec-once = [
    "~/.config/waybar/scripts/wallpaper/random-wallpaper.py"
    "~/.config/waybar/scripts/wallpaper/sync-wallpapers.py"
  ];
}
