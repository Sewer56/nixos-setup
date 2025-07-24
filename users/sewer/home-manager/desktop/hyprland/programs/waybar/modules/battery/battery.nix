{
  config = {
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
    #waybar.bar #custom-battery {
      color: #94e2d5;
    }

    #waybar.bar #custom-battery.warning {
      color: #f38ba8;
    }
  '';
}
