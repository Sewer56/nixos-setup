{...}: {
  wayland.windowManager.hyprland.settings = {
    # Theme color definitions
    "$accent" = "rgb(33ccff)";
    "$accent2" = "rgb(00ff99)";
    "$inactive" = "rgb(595959)";

    # General appearance settings
    general = {
      gaps_in = 5;
      gaps_out = 0;
      border_size = 2;
      "col.active_border" = "$accent $accent2 45deg";
      "col.inactive_border" = "$inactive";
    };

    # Decoration settings
    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
    };

    # Animations
    animations = {
      enabled = true;
      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
      ];
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
      "opacity 0.9 0.9, class:^(Code)$"
      "opacity 0.9 0.9, class:^(code-url-handler)$"

      # File manager transparency
      "opacity 0.9 0.9, class:^(thunar)$"
      "opacity 0.9 0.9, class:^(org.gnome.Nautilus)$"
      "opacity 0.9 0.9, class:^(dolphin)$"
    ];


    # Plugin configuration for dynamic cursors
    plugin = {
      dynamic-cursors = {
        enabled = true;
        mode = "tilt";

        # Tilt mode settings
        tilt = {
          limit = 25;
          function = "negative_quadratic";
        };

        # Rotate mode settings
        rotate = {
          length = 10;
          offset = 10;
        };

        # Stretch mode settings
        stretch = {
          limit = 0.2;
          function = "negative_quadratic";
        };

        # Shake to find cursor
        shake = {
          enabled = true;
          threshold = 10;
          base = 2;
          speed = 1;
          influence = 0.5;
          limit = 0.15;
          timeout = 2000;
          effects = false;
          IPC = true;
        };

        # Hyprcursor settings
        hyprcursor = {
          enabled = true;
          nearest_neighbor = false;
        };
      };
    };
  };
}
