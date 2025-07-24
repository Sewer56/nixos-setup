{
  config = {
    clock = {
      interval = 1;
      format = " {:%H:%M:%S   %d.%m}";
      tooltip-format = "{:%d.%m.%Y   Week %W}\n\n<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "month";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        format = {
          months = "<span color='#cba6f7'><b>{}</b></span>";
          days = "<span color='#cdd6f4'><b>{}</b></span>";
          weeks = "<span color='#94e2d5'> W{}</span>";
          weekdays = "<span color='#f9e2af'><b>{}</b></span>";
          today = "<span color='#f5e0dc'><b><u>{}</u></b></span>";
        };
      };
      on-click = "~/.config/waybar/scripts/launch-calendar.sh";
    };
  };

  style = ''
    #waybar.bar #clock {
      color: #a6e3a1;
    }
  '';
}
