{
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
    #waybar.first #backlight {
      color: #94e2d5;
    }
  '';
}
