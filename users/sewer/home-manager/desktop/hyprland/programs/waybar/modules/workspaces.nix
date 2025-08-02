semantic: {
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
        "1" = "󰈹"; # Browser icon
        "2" = "󰨞"; # Code icon
        "3" = "󰙯"; # Discord icon
        "4" = "󰒱"; # Slack icon
        "5" = "󰔀"; # Telegram icon
        "6" = "󰝚"; # General workspace icon
        "8" = "󰎈"; # Music icon
        "9" = "󰊢"; # Git icon
        "10" = "󰇮"; # Email icon
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
      color: ${semantic.border};
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
      color: ${semantic.work};
    }

    #waybar.bar #workspaces button.active {
      color: ${semantic.work};
      border: 1.5px solid ${semantic.border};
    }

    #waybar.bar #workspaces button:hover {
      color: ${semantic.work};
    }

    #waybar.bar #workspaces button.special.active {
      border: 1.5px solid transparent;
      color: ${semantic.work};
      transition: all 0s ease;
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-modifier-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }

    #waybar.bar #submap.RESIZE {
      color: ${semantic.resize};
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-modifier-text;
      animation-duration: 1s;
      animation-timing-function: steps(15);
    }

    #waybar.bar #window {
      color: ${semantic.work};
      margin-top: -0px;
    }

    #waybar.bar #window {
      min-width: 300px;
    }
  '';
}
