semantic: let
  helpers = import ../../../../themes/shared/helpers.nix;
in {
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
        color: ${semantic.warning};
      }
    }

    @keyframes blink-modifier-text {
      to {
        color: ${semantic.border};
      }
    }

    #waybar.bar {
      font-family: "JetBrains Mono Nerd Font Propo";
      font-size: 10pt;
      font-weight: 500;
    }

    #waybar.bar button {
      transition: all 0.15s ease-in-out;
    }

    tooltip {
      background: ${helpers.hexAlphaToCssRgba semantic.backgroundTransparent};
      border: 3px solid ${semantic.border};
      border-radius: 8px;
    }

    #waybar.bar #tray menu {
      background: ${helpers.hexAlphaToCssRgba semantic.backgroundTransparent};
      border: 3px solid ${semantic.border};
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
      color: ${semantic.border};
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-critical-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }
  '';

  chargingAnimationStyle = ''
    #waybar.bar #custom-battery.charging {
      color: ${semantic.power};
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-modifier-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }
  '';
}
