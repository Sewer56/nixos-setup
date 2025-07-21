{pkgs, ...}: {
  # Screenshot functionality for Hyprland
  home.packages = with pkgs; [
    grim # Screenshot utility for Wayland
    slurp # Region selection for screenshots
    wl-clipboard # Wayland clipboard utilities
  ];

  # Create Screenshots directory
  home.file."Pictures/Screenshots/.keep".text = "";

  wayland.windowManager.hyprland.settings = {
    bind = [
      # Screenshot selected area to clipboard
      ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      # Screenshot entire screen to clipboard
      "SHIFT, Print, exec, grim - | wl-copy"
      # Screenshot selected area to file
      "CTRL, Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
      # Screenshot entire screen to file
      "CTRL SHIFT, Print, exec, grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
    ];
  };
}
