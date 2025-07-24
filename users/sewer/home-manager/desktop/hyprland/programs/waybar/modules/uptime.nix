{
  config = {
    "custom/uptime" = {
      exec = "~/.config/waybar/scripts/uptime-since-resume.sh";
      interval = 30;
      format = "↑ {}";
      tooltip-format = "Time since last resume/boot: {}";
      tooltip = true;
    };
  };

  style = ''
    #waybar.bar #custom-uptime {
      color: #94e2d5;
    }
  '';
}
