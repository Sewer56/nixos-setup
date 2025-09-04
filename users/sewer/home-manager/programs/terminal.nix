{config, ...}: let
  colors = config.lib.theme.colors;
  semantic = config.lib.theme.semantic;
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

      # Theme color scheme
      colors = {
        primary = {
          background = semantic.background;
          foreground = semantic.foreground;
          dim_foreground = semantic.textSubtle;
          bright_foreground = semantic.text;
        };

        cursor = {
          text = semantic.background;
          cursor = semantic.interactiveHighlight;
        };

        vi_mode_cursor = {
          text = semantic.background;
          cursor = config.lib.theme.accent;
        };

        search = {
          matches = {
            foreground = semantic.background;
            background = semantic.textSubtle;
          };
          focused_match = {
            foreground = semantic.background;
            background = semantic.success;
          };
        };

        footer_bar = {
          foreground = semantic.text;
          background = semantic.mantle;
        };

        hints = {
          start = {
            foreground = semantic.background;
            background = semantic.highlight;
          };
          end = {
            foreground = semantic.background;
            background = semantic.textSubtle;
          };
        };

        selection = {
          text = semantic.background;
          background = semantic.interactiveHighlight;
        };

        normal = {
          black = semantic.surface1;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = semantic.textSubtle;
        };

        bright = {
          black = semantic.surface2;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = semantic.textDisabled;
        };

        dim = {
          black = semantic.surface1;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.pink;
          cyan = colors.teal;
          white = semantic.textSubtle;
        };

        indexed_colors = [
          {
            index = 16;
            color = semantic.contentHighlight;
          }
          {
            index = 17;
            color = semantic.interactiveHighlight;
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
        color = semantic.surface0;
        duration = 0;
      };

      # Keyboard bindings
      keyboard = {
        bindings = [
          {
            key = "Return";
            mods = "Shift";
            chars = "\n";
          }
        ];
      };
    };
  };
}
