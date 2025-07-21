{...}: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Rofi launcher bindings
      # See: /etc/nixos/users/sewer/home-manager/desktop/hyprland/bindings.nix
      # Current shortcuts:
      # - $mod + D: Application launcher (drun mode)
      # - $mod + R: Command runner (run mode)
      # - $mod + V: Clipboard history (clipboard mode) (in clipboard.nix)
      # - ALT + Tab: Window switcher
      # Theme is set via programs.rofi.theme in default.nix
      "$mod, D, exec, rofi -show drun"
      "$mod, R, exec, rofi -show run -theme ~/.config/rofi/themes/clipboard/laptop.rasi"
      "ALT, Tab, exec, rofi -show window"
    ];
  };
}
