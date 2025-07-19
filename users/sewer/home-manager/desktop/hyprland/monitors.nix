{...}: {
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration
    # Samsung Odyssey G95NC ultrawide
    #monitor = [
    # Format: name,resolution@rate,position,scale
    #  "DP-3,7680x2160@120,0x0,1.5"
    # Fallback for any other monitor
    #  ",preferred,auto,1"
    #];

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
      };

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification
    };
  };
}
