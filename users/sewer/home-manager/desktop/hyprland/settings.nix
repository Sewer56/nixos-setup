{...}: {
  wayland.windowManager.hyprland.settings = {
    # General settings
    general = {
      gaps_in = 5;
      gaps_out = 0;
      border_size = 2;
      "col.active_border" = "$accent $accent2 45deg";
      "col.inactive_border" = "$inactive";
      layout = "dwindle";
      allow_tearing = false;
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

    # Layout settings
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    # Gestures
    gestures = {
      workspace_swipe = false;
    };

    # Misc settings
    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = true;
      vfr = true; # Reduce amount of processed frames, saving battery.
    };

    # Cursor settings
    cursor = {
      enable_hyprcursor = true;
      no_warps = false;
      persistent_warps = true;
      warp_on_change_workspace = true;
      default_monitor = "monitor";
      zoom_factor = 1;
      zoom_rigid = false;
      use_cpu_buffer = false;
      hide_on_key_press = false;
      hide_on_touch = false;
    };
  };
}
