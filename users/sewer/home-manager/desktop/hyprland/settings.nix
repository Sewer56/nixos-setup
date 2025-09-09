{
  lib,
  hostOptions,
  ...
}: {
  wayland.windowManager.hyprland.settings = lib.mkMerge [
    {
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      # General settings
      general = {
        layout = "dwindle";
        allow_tearing = true; # Reduce latency in games at cost of tearing.
      };

      misc = {
        animate_manual_resizes = true; # enables animations for manual (keyboard) resizes
        vfr = true; # Reduce amount of processed frames, saving battery.
        disable_hyprland_logo = true; # Prevent logo from showing during wallpaper transitions
        disable_splash_rendering = true; # Disable splash rendering
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
        # Disable self-resizing of windows
        "suppressevent fullscreen maximize,class:^(.*)$"
        # Enable tearing for sonic.exe
        "immediate,class:^(sonic\.exe)$"
      ];

      debug = {
        disable_logs = false;
      };

      render = {
        direct_scanout = 1; # Enable direct scanout for better performance
      };

      misc = {
        vrr = 2; # Fullscreen only (else game flickers)
      };
    }

    # GPU configuration for dedicated laptop GPU
    (lib.mkIf hostOptions.desktop.hyprland.preferDedicatedLaptopGpu {
      env = [
        "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
      ];
    })
  ];
}
