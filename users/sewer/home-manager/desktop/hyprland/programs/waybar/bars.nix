{
  indicatorBar = {
    layer = "top";
    position = "top";
    name = "second";
    margin-top = 24;
    margin-left = 22;
    margin-right = 22;
    modules-center = [
      "battery"
    ];
  };

  mainBar = {
    layer = "top";
    position = "top";
    name = "first";
    margin-top = -39;
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
      "memory#ram"
      "memory#swap"
      "disk"
      "network#info"
      "bluetooth"
      "custom/spacer1"
      "pulseaudio#input"
      "pulseaudio#output"
      "custom/spacer1"
      "backlight"
      "custom/battery"
      "custom/spacer1"
      "clock"
    ];
  };

  indicatorBarStyle = ''
    @keyframes blink-critical-battery {
      to {
        border: 2.5px solid #f38ba8;
      }
    }

    @keyframes blink-charging-battery {
      to {
        border: 2.5px solid #94e2d5;
      }
    }

    #waybar.second,
    #waybar.third {
      font-size: 27px;
      color: rgba(0, 0, 0, 0);
      background: rgba(0, 0, 0, 0);
    }

    #waybar.second #battery {
      border: 2.5px solid #45475a;
      background: rgba(21, 21, 32, 0.75);
      transition: all 0.15s ease-in-out;
      border-radius: 8pt;
      padding-left: 1800px;
    }

    #waybar.second #battery.critical.discharging {
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-critical-battery;
      animation-duration: 1s;
      animation-timing-function: steps(15);
      transition: all 0.15s ease-in-out;
    }

    #waybar.second #battery.charging {
      animation-iteration-count: 2;
      animation-direction: alternate;
      animation-name: blink-charging-battery;
      animation-duration: 0.35s;
      animation-timing-function: steps(15);
      transition: all 0.15s ease-in-out;
    }

    #waybar.second #battery.discharging {
      animation-iteration-count: 2;
      animation-direction: alternate;
      animation-name: blink-critical-battery;
      animation-duration: 0.35s;
      animation-timing-function: steps(15);
      transition: all 0.15s ease-in-out;
    }
  '';
}
