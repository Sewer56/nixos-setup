{
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
      "custom/spacer3"
      "hyprland/submap"
      "hyprland/window"
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
      "custom/spacer1"
      "custom/uptime"
      "clock"
    ];
  };

  mainBarStyle = ''
    #waybar.bar {
      background: rgba(21, 21, 32, 0.75);
      border: 2.5px solid #45475a;
      border-radius: 8pt;
    }
  '';
}
