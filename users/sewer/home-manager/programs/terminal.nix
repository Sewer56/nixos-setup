{config, ...}: let
  colors = config.lib.catppuccin.colors;
in {
  programs.alacritty = {
    enable = true;

    settings = {
      # Window configuration
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_title = true;
      };

      # Font configuration
      font = {
        size = 12.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
      };

      # Catppuccin Mocha color scheme
      colors = {
        primary = {
          background = colors.base;
          foreground = colors.text;
          dim_foreground = colors.subtext0;
          bright_foreground = colors.text;
        };

        cursor = {
          text = colors.base;
          cursor = colors.rosewater;
        };

        vi_mode_cursor = {
          text = colors.base;
          cursor = colors.lavender;
        };

        search = {
          matches = {
            foreground = colors.base;
            background = colors.subtext0;
          };
          focused_match = {
            foreground = colors.base;
            background = colors.green;
          };
        };

        footer_bar = {
          foreground = colors.text;
          background = colors.mantle;
        };

        hints = {
          start = {
            foreground = colors.base;
            background = colors.yellow;
          };
          end = {
            foreground = colors.base;
            background = colors.subtext0;
          };
        };

        selection = {
          text = colors.base;
          background = colors.rosewater;
        };

        normal = {
          black = colors.surface1;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = colors.subtext1;
        };

        bright = {
          black = colors.surface2;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = colors.subtext0;
        };

        dim = {
          black = colors.surface1;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = colors.subtext1;
        };

        indexed_colors = [
          {
            index = 16;
            color = colors.peach;
          }
          {
            index = 17;
            color = colors.rosewater;
          }
        ];
      };

      # Scrolling
      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      # Bell
      bell = {
        animation = "EaseOutExpo";
        color = colors.surface0;
        duration = 0;
      };
    };
  };
}
