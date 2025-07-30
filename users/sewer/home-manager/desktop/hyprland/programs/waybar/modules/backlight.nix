semantic: {
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
      color: ${semantic.power};
    }
  '';
}
