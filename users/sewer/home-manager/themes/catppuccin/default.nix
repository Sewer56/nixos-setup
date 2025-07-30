{themeConfig, ...}: let
  # Import color definitions and accent mappings
  colorDefs = import ./colors.nix;
  accentMappings = import ./accent-mapping.nix;
  semanticColors = import ./semantic-colors.nix;
  sharedHelpers = import ../shared/helpers.nix;

  # Get colors for selected variant
  colors = colorDefs.palette.${themeConfig.variant};

  # Get current accent color
  accentColor = colors.${themeConfig.accent};

  # Get accent2 color from mapping - next color in hue progression for smooth gradients
  accent2ColorName = accentMappings.${themeConfig.accent} or "lavender";
  accent2Color = colors.${accent2ColorName};
in {
  # Raw color palette
  colors = colors;

  # Semantic color mappings using the shared definition
  semantic = semanticColors colors accentColor;

  # Current accent color
  accent = accentColor;

  # Secondary accent color - next color in hue progression for smooth gradients
  # Useful for borders, transitions, and multi-color effects
  accent2 = accent2Color;

  # Theme helpers
  helpers = sharedHelpers;

  # Theme metadata
  metadata = {
    name = "Catppuccin";
    variant = themeConfig.variant;
    accentName = themeConfig.accent;
    description = "Soothing pastel theme for the high-spirited!";
  };
}
