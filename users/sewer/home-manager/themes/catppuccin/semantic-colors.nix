# Catppuccin-specific semantic color definitions
# These define color roles/purposes using Catppuccin color palette
#
# Input format: colors should be hex strings (e.g., "#1e1e2e"), accent should be hex string
# Output format: All colors remain as hex strings.
#
# Documentation:
# - Catppuccin Colors: https://github.com/catppuccin/catppuccin#-palette
# - Catppuccin Style Guide: https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
#
# This configuration follows Catppuccin design principles:
# - "Colorful is better than colorless": Colors help distinguish structural elements
# - "There should be balance": Colors are suitable for various lighting conditions
# - "Harmony is superior to dissonance": Colors complement each other across the interface
colors: accent: let
  # Import shared helpers for color manipulation
  helpers = import ../shared/helpers.nix;
in {
  # UI State Colors - Core interface elements
  background = colors.base; # Primary background for terminal, rofi, notifications
  foreground = colors.text; # Primary text color for rofi, notifications
  border = colors.surface1; # Primary borders for waybar, tooltips, workspace buttons
  accent = accent; # Highlight color for notifications, lock screen, rofi

  # Status Colors - Semantic state indicators
  warning = colors.yellow; # CPU warnings, high-urgency notifications, caps lock, network issues
  success = colors.green; # Terminal focused search matches, positive feedback
  info = colors.blue; # Information states (currently unused - available for tooltips)
  error = colors.red; # Lock screen authentication failures, critical states

  # Functional Colors - Domain-specific semantic groupings
  # These create visual consistency by grouping related functionality
  audio = colors.mauve; # Audio controls, volume indicators, calendar months
  power = colors.teal; # Battery, charging states, uptime, backlight, calendar weeks
  date = colors.green; # Clock display, time-related elements
  work = colors.lavender; # Workspace buttons, window management, productivity contexts
  window = colors.lavender; # Window management (same as work - consider differentiating)
  resize = colors.maroon; # Hyprland resize mode, window manipulation states
  performance = colors.pink; # System metrics (bluetooth, memory, disk, network)

  # Text Hierarchy - Progressive text prominence levels
  text = colors.text; # Primary text (terminal bright foreground, lock screen, waybar)
  textSubtle = colors.subtext1; # Secondary text (terminal dim, search backgrounds, ANSI white)
  textDisabled = colors.overlay0; # Disabled/subtle text (mapped from overlay0 - most faded)

  # Surface Hierarchy - Progressive background depth levels
  # Following Catppuccin: base < mantle < surface0 < surface1 < surface2
  surface0 = colors.surface0; # Subtle backgrounds (terminal bell, inactive borders, progress bars)
  surface1 = colors.surface1; # Secondary backgrounds (ANSI black, shell history, search fields)
  surface2 = colors.surface2; # Prominent surfaces (terminal bright black, completion highlights)
  mantle = colors.mantle; # Deep backgrounds (terminal footer, scrollbar tracks)

  # Overlay Hierarchy - Progressive overlay prominence (overlay0 = most subtle)
  # Per Catppuccin style guide: overlay2 recommended at 20-30% opacity for selections
  overlay0 = colors.overlay0; # Most subtle (shell delimiters, comments, autosuggestions, starship time)
  overlay1 = colors.overlay1; # Intermediate level (currently unused - available for intermediate states)
  overlay2 = colors.overlay2; # Most prominent (rofi selections at 30% opacity - follows style guide)

  # Interactive and Content Highlighting - Well-defined semantic purposes
  # These colors serve distinct roles and follow consistent patterns

  # Active/Selected States (Rosewater - warm, prominent)
  interactiveHighlight = colors.rosewater; # Terminal cursor/selection, wallpaper controls, calendar today

  # Special Content Types (Peach - distinctive for content)
  contentHighlight = colors.peach; # Shell quoted arguments, terminal palette, starship packages

  # Command and UI Interaction (Yellow - attention-grabbing for interactive elements)
  command = colors.yellow; # Shell command options/globbing/redirection, starship git/duration
  highlight = colors.yellow; # Search results, history highlighting, terminal hints, completion descriptions
  interactive = colors.yellow; # UI hover states, calendar weekdays, interactive elements

  # Dynamic transparent background (for waybar) - 75% opacity
  backgroundTransparent = helpers.hexToRgbaHex colors.base "bf";
}
