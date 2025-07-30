semantic: {
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
          months = "<span color='${semantic.audio}'><b>{}</b></span>";
          days = "<span color='${semantic.text}'><b>{}</b></span>";
          weeks = "<span color='${semantic.power}'> W{}</span>";
          weekdays = "<span color='${semantic.interactive}'><b>{}</b></span>";
          today = "<span color='${semantic.interactiveHighlight}'><b><u>{}</u></b></span>";
        };
      };
      on-click = "~/.config/waybar/scripts/launch-calendar.sh";
    };
  };

  style = ''
    #waybar.bar #clock {
      color: ${semantic.date};
    }
  '';
}
