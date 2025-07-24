{
  config = {
    cpu = {
      interval = 4;
      tooltip = " {load}";
      format = " {usage}%";
      states = {
        warning = 80;
        critical = 95;
      };
    };

    "memory#ram" = {
      interval = 4;
      format = " {percentage}%";
      states = {
        warning = 80;
        critical = 95;
      };
      tooltip = "{}";
      tooltip-format = "{used}/{total} GiB";
    };

    "memory#swap" = {
      interval = 6;
      format = "󰾵 {swapPercentage}%";
      tooltip = "{}";
      tooltip-format = "{swapUsed}/{swapTotal}GiB";
    };

    temperature = {
      critical-threshold = 90;
      interval = 4;
      # Laptop specific!
      thermal-zone = 7;
      format = "{icon} {temperatureC}°";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      tooltip = false;
    };

    disk = {
      interval = 10;
      format = " {percentage_used}%";
      tooltip = "{}";
      tooltip-format = "Free {free}";
      on-click = "~/.config/waybar/scripts/launch-disk-analyzer.sh";
      states = {
        warning = 85;
        critical = 95;
      };
    };
  };

  style = ''
    #waybar.bar #cpu,
    #waybar.bar #temperature,
    #waybar.bar #memory.ram,
    #waybar.bar #memory.swap,
    #waybar.bar #disk {
      color: #f5c2e7;
    }
  '';
}
