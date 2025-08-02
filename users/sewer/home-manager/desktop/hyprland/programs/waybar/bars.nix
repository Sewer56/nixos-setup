semantic: let
  helpers = import ../../../../themes/shared/helpers.nix;
in {
  mainBar = {
    layer = "top";
    position = "top";
    name = "bar";
    mode = "hide";
    # Bar will stretch to actual needed width.
    width = 2;
    margin-left = 24;
    margin-right = 24;
    modules-left = [
      "tray"
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

  bottomBar = {
    layer = "top";
    position = "bottom";
    name = "bottom-bar";
    mode = "hide";
    # Center the workspaces
    width = 2;
    margin-left = 24;
    margin-right = 24;
    margin-bottom = 24;
    modules-center = [
      "custom/spacer2"
      "hyprland/workspaces"
      "custom/spacer2"
    ];
  };

  mainBarStyle = ''
    #waybar.bar {
      background: ${helpers.hexAlphaToCssRgba semantic.backgroundTransparent};
      border: 2.5px solid ${semantic.border};
      border-radius: 8pt;
    }
  '';

  bottomBarStyle = ''
    #waybar.bottom-bar {
      background: ${helpers.hexAlphaToCssRgba semantic.backgroundTransparent};
      border: 2.5px solid ${semantic.border};
      border-radius: 8pt;
    }
  '';
}
