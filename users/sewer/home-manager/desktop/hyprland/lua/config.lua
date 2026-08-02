-- Core Hyprland configuration
-- See https://wiki.hypr.land/Configuring/Basics/ for more

-- Non-declarative monitor overrides (created by home-manager activation)
require("monitors")

hl.config({
  general = {
    layout = "dwindle";
    allow_tearing = true; -- Reduce latency in games at cost of tearing.
  };

  misc = {
    animate_manual_resizes = true; -- enables animations for manual (keyboard) resizes
    disable_hyprland_logo = true; -- Prevent logo from showing during wallpaper transitions
    disable_splash_rendering = true; -- Disable splash rendering
    vrr = 3; -- Fullscreen only (game/video only)
  };

  -- Layout settings
  dwindle = {
    -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
    preserve_split = true; -- you probably want this
  };

  master = {
    -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
    orientation = "center";
    always_keep_position = true;
    slave_count_for_center_master = 0;
    allow_small_split = true;
  };

  debug = {
    disable_logs = false;
    full_cm_proto = true;
  };

  render = {
    direct_scanout = 1; -- Enable direct scanout for lower latency in fullscreen.
  };

  -- unscale XWayland
  xwayland = {
    force_zero_scaling = true;
  };

  input = {
    kb_layout = "us";
    kb_variant = "";
    kb_model = "";
    kb_options = "";
    kb_rules = "";

    follow_mouse = 1;

    touchpad = {
      natural_scroll = false;
      scroll_factor = 0.666666666;
      drag_lock = 0;
    };

    sensitivity = 0; -- -1.0 - 1.0, 0 means no modification
  };
})

-- Window rules (Hyprland 0.54+ unified syntax)
hl.window_rule({
  -- WINE fix
  no_max_size = true;
  match = { class = "^(winecfg\\.exe)$" };
})
hl.window_rule({
  no_max_size = true;
  match = { class = "^(.*)$" };
})
-- Disable self-resizing of windows
hl.window_rule({
  suppress_event = "fullscreen maximize";
  match = { class = "^(.*)$" };
})
-- Enable tearing for sonic.exe
hl.window_rule({
  immediate = true;
  match = { class = "^(sonic\\.exe)$" };
})
