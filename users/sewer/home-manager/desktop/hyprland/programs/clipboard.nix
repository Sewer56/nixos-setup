{pkgs, ...}: {
  # Clipboard management for Hyprland
  home.packages = with pkgs; [
    cliphist # Clipboard history manager for Wayland
  ];

  # Clipboard history tracking and SUPER+V binding are in
  # lua/autostart.lua and lua/binds.lua
}
