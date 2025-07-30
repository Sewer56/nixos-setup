{
  config,
  lib,
  ...
}: let
  cfg = config.theme;

  # Import available themes (just the theme definitions, not system integration)
  availableThemes = {
    catppuccin = import ./catppuccin/default.nix {
      inherit lib;
      themeConfig = cfg;
    };
  };

  # Get the selected theme
  selectedTheme = availableThemes.${cfg.name} or (throw "Unknown theme: ${cfg.name}");
in {
  # Theme selection option
  options.theme = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin";
      description = "The theme to use for the system";
      example = "catppuccin";
    };

    # Allow themes to define their own options
    variant = lib.mkOption {
      type = lib.types.str;
      default = "mocha";
      description = "Theme variant/flavor to use";
      example = "mocha";
    };

    accent = lib.mkOption {
      type = lib.types.str;
      default = "lavender";
      description = "Theme accent color";
      example = "lavender";
    };
  };

  # Provide the universal theme interface
  config = {
    lib.theme = {
      # Raw color palette from selected theme
      colors = selectedTheme.colors;

      # Semantic color mappings
      semantic = selectedTheme.semantic;

      # Theme-specific helpers
      helpers = selectedTheme.helpers or {};

      # Current accent color
      accent = selectedTheme.accent;

      # Secondary accent color - next color in hue progression for smooth gradients
      # Useful for borders, transitions, and multi-color effects like Hyprland borders
      accent2 = selectedTheme.accent2 or selectedTheme.accent;

      # Theme metadata
      metadata = selectedTheme.metadata or {};
    };
  };
}
