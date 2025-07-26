{config, ...}: let
  colors = config.lib.catppuccin.colors;
in {
  services.mako = {
    enable = true;
    settings = {
      # Colors using Catppuccin theme
      background-color = colors.base;
      text-color = colors.text;
      border-color = colors.${config.catppuccin.accent};
      progress-color = "over ${colors.surface0}";

      # Layout and appearance
      max-visible = 10;
      layer = "top";
      font = "JetBrains Mono Nerd Font 10";
      border-radius = 7;
      max-icon-size = 48;
      default-timeout = 20000;
      anchor = "top-center";
      outer-margin = 30;
      margin = 20;

      # High urgency notifications
      "urgency=high" = {
        border-color = colors.peach;
      };
    };
  };
}
