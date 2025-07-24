{
  config = {
    "hyprland/workspaces" = {
      disable-scroll-wraparound = true;
      smooth-scrolling-threshold = 4;
      enable-bar-scroll = true;
      format = "{icon}";
      show-special = true;
      special-visible-only = false;
      format-icons = {
        magic = "";
        "10" = "󰊴 ";
      };
    };

    "hyprland/submap" = {
      always-on = true;
      default-submap = "";
      format = "󰲏";
      format-RESIZE = "{}";
      tooltip = false;
    };

    "hyprland/window" = {
      format = "{title}";
      max-length = 48;
      icon = true;
      icon-size = 18;
      tooltip = true;
    };
  };

  style = ''
    #waybar.bar #workspaces button {
      color: #45475a;
      background: transparent;
      border: 1.5px solid transparent;
      font-size: 10pt;
      padding-left: 2pt;
      padding-right: 2pt;
      border-radius: 16px;
      margin-bottom: 6px;
      margin-top: 6px;
      margin-left: 4px;
      margin-right: 4px;
      transition: all 0.25s ease;
    }

    #waybar.bar #workspaces button.visible {
      color: #b4befe;
    }

    #waybar.bar #workspaces button.active {
      color: #b4befe;
      border: 1.5px solid #45475a;
    }

    #waybar.bar #workspaces button:hover {
      color: #b4befe;
    }

    #waybar.bar #workspaces button.special.active {
      border: 1.5px solid transparent;
      color: #b4befe;
      transition: all 0s ease;
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-modifier-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }

    #waybar.bar #submap.RESIZE {
      color: #eba0ac;
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-modifier-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }

    #waybar.bar #window {
      color: #b4befe;
      margin-top: -0px;
    }
  '';
}
