semantic: let
  helpers = import ../../../../themes/shared/helpers.nix;
in {
  mainBar = {
    layer = "top";
    position = "bottom";
    name = "bar";
    mode = "hide";
    # Bar will stretch to actual needed width.
    width = 2;
    margin-left = 24;
    margin-right = 24;
    modules-left = [
      "tray"
      "custom/spacer3"
      "custom/spacer2"
      "hyprland/workspaces"
      "custom/spacer2"
      "group/wallpaper"
      "custom/spacer2"
      # "custom/spacer3"
      # "hyprland/submap"
      # "hyprland/window"
    ];
    modules-right = [
      "custom/spacer1"
      "cpu"
      "temperature"
      "group/memory-storage"
      "network#info"
      # "bluetooth"
      "custom/spacer1"
      "group/audio"
      "custom/spacer1"
      "backlight"
      "custom/battery"
      "custom/uptime"
      "custom/spacer1"
      "clock"
    ];
  };

  mainBarStyle = ''
    #waybar.bar {
      background: ${helpers.hexAlphaToCssRgba semantic.backgroundTransparent};
      border: 2.5px solid ${semantic.border};
      border-radius: 8pt;
    }
  '';
}
