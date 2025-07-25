catppuccin: {
  colors = {
    background = "rgba(21, 21, 32, 0.75)";
    warning = catppuccin.red;
    border = catppuccin.surface1;
    performance = catppuccin.pink;
    audio = catppuccin.mauve;
    power = catppuccin.teal;
    date = catppuccin.green;
    work = catppuccin.lavender;
    window = catppuccin.lavender;
    resize = catppuccin.maroon;
    text = catppuccin.text;
    yellow = catppuccin.yellow;
    rosewater = catppuccin.rosewater;
  };

  baseStyle = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      margin: 0;
      padding: 0;
      box-shadow: none;
      text-shadow: none;
    }

    @keyframes blink-critical-text {
      to {
        color: ${catppuccin.red};
      }
    }

    @keyframes blink-modifier-text {
      to {
        color: ${catppuccin.surface1};
      }
    }

    #waybar.bar {
      font-family: "JetBrains Mono Nerd Font";
      font-size: 10pt;
      font-weight: 500;
    }

    #waybar.bar button {
      font-family: JetBrains Mono Nerd Font;
      font-size: 12pt;
      font-weight: 500;
      transition: all 0.15s ease-in-out;
    }

    tooltip {
      background: rgba(21, 21, 32, 0.75);
      border: 3px solid ${catppuccin.surface1};
      border-radius: 8px;
    }

    #waybar.bar #tray menu {
      background: rgba(21, 21, 32, 0.75);
      border: 3px solid ${catppuccin.surface1};
      border-radius: 8px;
    }
  '';

  moduleBaseStyle = ''
    #waybar.bar #custom-battery,
    #waybar.bar #custom-uptime,
    #waybar.bar #network,
    #waybar.bar #backlight,
    #waybar.bar #clock,
    #waybar.bar #cpu,
    #waybar.bar #memory.swap,
    #waybar.bar #memory.ram,
    #waybar.bar #submap,
    #waybar.bar #pulseaudio,
    #waybar.bar #temperature,
    #waybar.bar #tray,
    #waybar.bar #window,
    #waybar.bar #disk {
      padding-left: 8pt;
      padding-right: 8pt;
      padding-bottom: 4px;
      padding-top: 4px;
      background: transparent;
    }
  '';

  criticalAnimationStyle = ''
    #waybar.bar #custom-battery.critical,
    #waybar.bar #workspaces button.urgent,
    #waybar.bar #workspaces button.special.urgent,
    #waybar.bar #memory.swap.critical,
    #waybar.bar #memory.ram.critical,
    #waybar.bar #cpu.critical,
    #waybar.bar #temperature.critical {
      color: ${catppuccin.surface1};
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-critical-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }
  '';

  chargingAnimationStyle = ''
    #waybar.bar #custom-battery.charging {
      color: ${catppuccin.teal};
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-modifier-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }
  '';
}
