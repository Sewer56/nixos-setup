{
  config,
  inputs,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;

    settings = {
      ipc = "on";
      splash = false;
    };
  };

  # Set random wallpaper and sync collection in background
  wayland.windowManager.hyprland.settings = {
    exec = [
      "~/.config/waybar/scripts/wallpaper/startup-wrapper.py"
      "hyprctl setcursor catppuccin-${config.theme.variant}-${config.theme.accent}-cursors 32"
    ];
    exec-once = [
      "~/.config/waybar/scripts/wallpaper/sync-wallpapers.py"
      "~/.config/waybar/scripts/wallpaper/startup-sync.py"
    ];
  };
}
