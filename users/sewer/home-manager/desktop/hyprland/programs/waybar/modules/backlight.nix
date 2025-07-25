theme: {
  config = {
    backlight = {
      device = "intel_backlight";
      format = "{icon} {percent}%";
      format-icons = [
        "󱩎"
        "󱩑"
        "󱩓"
        "󱩕"
        "󰛨"
      ];
      scroll-step = 5;
    };
  };

  style = ''
    #waybar.bar #backlight {
      color: ${theme.colors.power};
    }
  '';
}
