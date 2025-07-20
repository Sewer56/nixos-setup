{config, ...}: let
  # Import accent mapping
  accentMappings = import ./accent-mapping.nix;
  accent2Color = accentMappings.${config.catppuccin.accent} or "rgb(00ff99)";
in {
  wayland.windowManager.hyprland.settings = {
    # Theme color definitions - using Catppuccin colors
    "$accent" = "$accent"; # This will use Catppuccin's accent color
    "$accent2" = accent2Color;
    "$inactive" = "$surface0"; # Using Catppuccin surface color

    general = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      gaps_in = 5;
      gaps_out = 0;
      border_size = 2;
      "col.active_border" = "$accent $accent2 45deg";
      "col.inactive_border" = "$inactive";
    };

    decoration = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      rounding = 10;

      blur = {
        enabled = true;
      };
    };

    animations = {
      enabled = true;

      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    # Window transparency rules
    windowrulev2 = [
      # Terminal transparency
      "opacity 0.9 0.9, class:^(Alacritty)$"
      "opacity 0.9 0.9, class:^(kitty)$"
      "opacity 0.9 0.9, class:^(org.wezfurlong.wezterm)$"

      # Code editor transparency
      "opacity 0.9 0.9, class:^(code)$"
      "opacity 0.9 0.9, class:^(code-url-handler)$"

      # File manager transparency
      "opacity 0.9 0.9, class:^(thunar)$"
      "opacity 0.9 0.9, class:^(org.gnome.Nautilus)$"
      "opacity 0.9 0.9, class:^(dolphin)$"
    ];
  };
}
