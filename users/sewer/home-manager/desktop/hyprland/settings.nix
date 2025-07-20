{...}: {
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Keywords/ for more

    # General settings
    general = {
      layout = "dwindle";
    };

    misc = {
      animate_manual_resizes = true; # enables animations for manual (keyboard) resizes
      vfr = true; # Reduce amount of processed frames, saving battery.
    };

    # Layout settings
    dwindle = {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # you probably want this
    };

    master = {
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      orientation = "center";
      always_keep_position = true;
      slave_count_for_center_master = 0;
      allow_small_split = true;
    };

    # Gestures
    gestures = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = false;
    };

    # Example windowrule v1
    windowrule = [
      # WINE fix
      "nomaxsize,class:^(winecfg\.exe)$"
      "nomaxsize,class:^(.*)$"
    ];

    debug = {
      disable_logs = false;
    };
  };
}
