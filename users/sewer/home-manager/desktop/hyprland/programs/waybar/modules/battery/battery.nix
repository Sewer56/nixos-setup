theme: {
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
      color: ${theme.colors.misc};
    }

    #waybar.bar #custom-battery.warning {
      color: ${theme.colors.warning};
    }
  '';
}
