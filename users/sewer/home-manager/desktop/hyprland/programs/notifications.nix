{
  config,
  lib,
  ...
}: let
  colors = config.lib.theme.colors;
  semantic = config.lib.theme.semantic;
in {
  services.mako = {
    enable = true;
    settings = {
      # Colors using current theme
      background-color = semantic.background;
      text-color = semantic.foreground;
      border-color = semantic.accent;
      progress-color = "over ${semantic.surface0}";

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
        border-color = lib.mkForce semantic.warning;
      };
    };
  };
}
