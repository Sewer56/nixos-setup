{...}: {
  wayland.windowManager.hyprland.settings = {
    # Catppuccin Mocha color definitions
    "$rosewater" = "rgb(f5e0dc)";
    "$flamingo" = "rgb(f2cdcd)";
    "$pink" = "rgb(f5c2e7)";
    "$mauve" = "rgb(cba6f7)";
    "$red" = "rgb(f38ba8)";
    "$maroon" = "rgb(eba0ac)";
    "$peach" = "rgb(fab387)";
    "$yellow" = "rgb(f9e2af)";
    "$green" = "rgb(a6e3a1)";
    "$teal" = "rgb(94e2d5)";
    "$sky" = "rgb(89dceb)";
    "$sapphire" = "rgb(74c7ec)";
    "$blue" = "rgb(89b4fa)";
    "$lavender" = "rgb(b4befe)";
    "$text" = "rgb(cdd6f4)";
    "$subtext1" = "rgb(bac2de)";
    "$subtext0" = "rgb(a6adc8)";
    "$overlay2" = "rgb(9399b2)";
    "$overlay1" = "rgb(7f849c)";
    "$overlay0" = "rgb(6c7086)";
    "$surface2" = "rgb(585b70)";
    "$surface1" = "rgb(45475a)";
    "$surface0" = "rgb(313244)";
    "$base" = "rgb(1e1e2e)";
    "$mantle" = "rgb(181825)";
    "$crust" = "rgb(11111b)";

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

    # Cursor configuration with dynamic effects
    cursor = {
      no_break_fs_vrr = false;
      min_refresh_rate = 60;
      persistent_warps = true;
      warp_on_change_workspace = true;
      default_monitor = "monitor";
      zoom_factor = 1;
      zoom_rigid = false;
      enable_hyprcursor = true;
      hide_on_key_press = false;
      hide_on_touch = false;
    };

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
