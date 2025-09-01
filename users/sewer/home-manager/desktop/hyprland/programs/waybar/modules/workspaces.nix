{
  semantic,
  lib,
  hostOptions,
}: {
  config = {
    "hyprland/workspaces" = {
      disable-scroll-wraparound = true;
      smooth-scrolling-threshold = 4;
      enable-bar-scroll = true;
      format = "{icon}";
      show-special = true;
      special-visible-only = false;
      format-icons =
        if hostOptions.desktop.hyprland.displayMode == "ultrawide"
        then {
          # Ultrawide mode: Focus on workspaces 1-4 with layout-optimized assignments
          magic = "";
          "1" = "󰈹"; # Code/Browser (master layout)
          "2" = "󰊢"; # Development tools (master layout)
          "3" = "󰒱"; # Communications (master layout)
          "4" = "󰝚"; # Miscellaneous (dwindle layout)
        }
        else if hostOptions.desktop.hyprland.displayMode == "threeScreens"
        then {
          # Three-screen mode: Office setup with specific monitor assignments
          magic = "";
          "1" = "󰈹"; # Vivaldi - Left screen (DP-4)
          "2" = "󰨞"; # Code - Middle screen (DP-3)
          "3" = "󰒱"; # Slack + Discord - Right screen (eDP-1)
          "4" = "󰆾"; # Other apps - Right screen
          "7" = "//"; # Visual separator
          "8" = "󰎈"; # Music icon
          "9" = "󰊢"; # Git icon
          "10" = "󰇮"; # Email icon
        }
        else {
          # Standard mode: Full workspace range 1-10
          magic = "";
          "1" = "󰈹"; # Browser icon
          "2" = "󰨞"; # Code icon
          "3" = "󰙯"; # Discord icon
          "4" = "󰒱"; # Slack icon
          "5" = "󰆾"; # Telegram icon (alternative)
          "6" = "󰝚"; # General workspace icon
          "7" = "//"; # Visual separator between low and high workspaces
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
    #waybar.bar #workspaces button, #waybar.bottom-bar #workspaces button {
      color: ${semantic.border};
      background: transparent;
      font-size: 14pt; /* Font size + 4 */
      padding-left: 2pt;
      padding-right: 2pt;
      margin-left: 4px;
      margin-right: 4px;
      transition: all 0.25s ease;
    }

    #waybar.bar #workspaces button.visible, #waybar.bottom-bar #workspaces button.visible {
      color: ${semantic.work};
    }

    #waybar.bar #workspaces button.active, #waybar.bottom-bar #workspaces button.active {
      color: ${semantic.work};
    }

    #waybar.bar #workspaces button:hover, #waybar.bottom-bar #workspaces button:hover {
      color: ${semantic.work};
    }

    #waybar.bar #workspaces button.special.active, #waybar.bottom-bar #workspaces button.special.active {
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
