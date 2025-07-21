{pkgs, ...}: {
  # Clipboard management for Hyprland
  home.packages = with pkgs; [
    cliphist # Clipboard history manager for Wayland
  ];

  wayland.windowManager.hyprland.settings = {
    # Start clipboard history tracking
    exec-once = [
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];

    bind = [
      # Open clipboard manager
      "$mod, V, exec, cliphist list | rofi -dmenu -theme ~/.config/rofi/themes/clipboard/laptop.rasi | cliphist decode | wl-copy"
    ];
  };
}
