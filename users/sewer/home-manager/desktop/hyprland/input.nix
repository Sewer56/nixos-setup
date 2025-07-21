{...}: {
  wayland.windowManager.hyprland.settings = {
    # Input configuration
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

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification
    };
  };
}
