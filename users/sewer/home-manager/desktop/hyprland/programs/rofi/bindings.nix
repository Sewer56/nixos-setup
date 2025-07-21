{...}: {
  # Rofi keybindings for Hyprland
  # Documentation:
  # - Rofi Manual: https://github.com/davatorium/rofi/blob/next/doc/rofi.1.markdown
  # - Rofi Modi: https://github.com/davatorium/rofi/blob/next/doc/rofi.1.markdown#modi
  # - Emoji Plugin: https://github.com/Mange/rofi-emoji
  # - Hyprland Binds: https://wiki.hyprland.org/Configuring/Binds/
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Rofi launcher bindings
      # Current shortcuts:
      # - $mod + D: Application launcher (drun mode)
      # - $mod + R: Command runner (run mode)
      # - $mod + V: Clipboard history (clipboard mode) (in clipboard.nix)
      # - $mod + .: Emoji picker (emoji mode) with simplified format
      # - ALT + Tab: Window switcher
      # Theme is set via programs.rofi.theme in default.nix
      "$mod, D, exec, rofi -show drun"
      "$mod, R, exec, rofi -show run -theme ~/.config/rofi/themes/clipboard/laptop.rasi"
      "$mod, period, exec, rofi -show emoji -emoji-mode copy -emoji-format '{emoji} <span weight=\"light\">{name}</span>' -theme ~/.config/rofi/themes/emoji/laptop.rasi"
      "ALT, Tab, exec, rofi -show window"
    ];
  };
}
