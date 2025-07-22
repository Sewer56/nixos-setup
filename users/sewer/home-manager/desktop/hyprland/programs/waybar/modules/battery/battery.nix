{
  config = {
    battery = {
      interval = 5;
      states = {
        warning = 20;
        critical = 10;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-balanced = "balanced {capacity}%";
      format-charging-full = " {capacity}%";
      format-full = "{icon} {capacity}%";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      tooltip = "{}";
      tooltip-format = " {power}W";
    };

    "custom/battery" = {
      interval = 5;
      return-type = "json";
      exec = "~/.config/waybar/modules/battery/bat-pp.sh refresh";
      exec-on-event = true;
      format = "{text}%";
      on-click = "~/.config/waybar/modules/battery/bat-pp.sh toggle";
      tooltip = "true";
      tooltip-format = "{alt}W";
    };
  };

  style = ''
    #waybar.first #custom-battery,
    #waybar.first #battery {
      color: #94e2d5;
    }

    #waybar.first #custom-battery.warning,
    #waybar.first #battery.warning.discharging {
      color: #f38ba8;
    }
  '';
}
