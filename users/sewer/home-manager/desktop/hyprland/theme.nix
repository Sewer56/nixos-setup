{...}: {
  wayland.windowManager.hyprland.settings = {
    # Theme color definitions
    "$accent" = "rgb(33ccff)";
    "$accent2" = "rgb(00ff99)";
    "$inactive" = "rgb(595959)";

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
