{...}: {
  wayland.windowManager.hyprland.settings = {
    # General settings
    general = {
      layout = "dwindle";
      allow_tearing = false;
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
