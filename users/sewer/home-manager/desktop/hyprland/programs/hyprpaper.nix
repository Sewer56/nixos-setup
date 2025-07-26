{...}: {
  services.hyprpaper.enable = true;

  # Start wallpaper management at login
  wayland.windowManager.hyprland.settings.exec-once = [
    "~/.config/waybar/scripts/wallpaper/startup-wallpaper.py"
  ];
}
