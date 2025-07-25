theme: {
  config = {
    "bluetooth" = {
      format = "󰂯";
      format-disabled = "󰂯";
      format-connected = "󰂯 {device_alias}";
      format-connected-battery = "󰂯 {device_alias} {device_battery_percentage}%";
      tooltip-format = "{controller_alias}\t{controller_address}";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
      on-click = "~/.config/waybar/scripts/launch-bluetooth-manager.sh";
    };
  };

  style = ''
    #waybar.bar #bluetooth {
      color: ${theme.colors.performance};
      padding-right: 15px;
    }

    #waybar.bar #bluetooth.disabled {
      color: ${theme.colors.border};
      padding-right: 15px;
    }

    #waybar.bar #bluetooth.off {
      color: ${theme.colors.border};
      padding-right: 15px;
    }
  '';
}
