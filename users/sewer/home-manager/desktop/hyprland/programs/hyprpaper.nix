{...}: {
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
    };
  };

  # Set random wallpaper and sync collection in background
  wayland.windowManager.hyprland.settings = {
    exec = [
      "~/.config/waybar/scripts/wallpaper/startup-wrapper.py"
    ];
    exec-once = [
      "~/.config/waybar/scripts/wallpaper/sync-wallpapers.py"
    ];
  };
}
