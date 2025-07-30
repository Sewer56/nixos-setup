# Catppuccin-specific semantic color definitions
# These define color roles/purposes using Catppuccin color palette
#
# Input format: colors should be hex strings (e.g., "#1e1e2e"), accent should be hex string
# Output format: All colors remain as hex strings.
#
# Documentation:
# - Catppuccin Colors: https://github.com/catppuccin/catppuccin#-palette
# - Catppuccin Style Guide: https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
# Colors follow Catppuccin style guide: https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
colors: accent: let
  # Import shared helpers for color manipulation
  helpers = import ../shared/helpers.nix;
in {
  # UI State Colors
  background = colors.base;
  foreground = colors.text;
  border = colors.surface1;
  accent = accent;

  # Status Colors
  warning = colors.yellow;
  success = colors.green;
  info = colors.blue;
  error = colors.red;

  # Functional Colors (Catppuccin-specific semantic mappings)
  audio = colors.mauve;
  power = colors.teal;
  date = colors.green;
  work = colors.lavender;
  window = colors.lavender;
  resize = colors.maroon;
  performance = colors.pink;

  # Text Hierarchy
  text = colors.text;
  textSubtle = colors.subtext1;
  textDisabled = colors.overlay0;

  # Surface Hierarchy
  surface0 = colors.surface0;
  surface1 = colors.surface1;
  surface2 = colors.surface2;
  mantle = colors.mantle;

  # Overlay Hierarchy
  overlay0 = colors.overlay0;
  overlay1 = colors.overlay1;
  overlay2 = colors.overlay2;

  # Interactive and Content Highlighting
  interactiveHighlight = colors.rosewater; # Cursors, selections, active states, current day
  contentHighlight = colors.peach; # Variables, package info, special content types

  # Command and UI Interaction Colors
  command = colors.yellow; # Shell command syntax elements
  highlight = colors.yellow; # Search matches and found content
  interactive = colors.yellow; # UI interactive elements and hover states

  # Dynamic transparent background (for waybar) - 75% opacity
  backgroundTransparent = helpers.hexToRgbaHex colors.base "bf";
}
