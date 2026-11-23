# Theme Interface Documentation

## Universal Theme Interface

### Required Exports

Every theme's `default.nix` must export an attribute set containing:

#### `colors` (required)

Raw color palette with at minimum these colors:

- `base` - Primary background color
- `text` - Primary text color  
- `red`, `green`, `blue`, `yellow` - Primary colors
- `surface0`, `surface1`, `surface2` - Background hierarchy
- `overlay0`, `overlay1`, `overlay2` - Overlay hierarchy
- `subtext0`, `subtext1` - Text hierarchy
- `mantle` - Deeper background surface
- Theme-specific colors as needed

#### `semantic` (required)

Semantic color mappings defined within each theme's own `semantic-colors.nix`:
- **UI State**: `background`, `foreground`, `border`, `accent`
- **Status Colors**: `warning`, `success`, `info`, `error`
- **Functional Colors**: `audio`, `power`, `date`, `work`, `window`, `resize`, `performance`
- **Text Hierarchy**: `text`, `textSubtle`, `textDisabled`
- **Surface Hierarchy**: `surface0`, `surface1`, `surface2`, `mantle`
- **Overlay Hierarchy**: `overlay0`, `overlay1`, `overlay2`
- **Content Highlighting**: `interactiveHighlight`, `contentHighlight`
- **Command & UI**: `command`, `highlight`, `interactive`

#### `accent` (required)

Current accent color, from the palette.

#### `accent2` (optional)

Next color in hue after `accent`, for gradients such as Hyprland borders.
Falls back to `accent`.

#### `accentColors` (optional)

Accent color names mapped to hex values, for the accent color export.
Catppuccin lists all 14: rosewater, flamingo, pink, mauve, red, maroon, peach, yellow,
green, teal, sky, sapphire, blue, lavender.

#### `helpers` (optional)

Color converters from `../shared/helpers.nix`:
- `hexToRgbHyprland` - Convert hex to Hyprland rgb format
- `hexToRgbaHyprland` - Convert hex to Hyprland rgba format  
- `hexToRgbaHex` - Convert hex to hex rgba format
- `hexToCssRgba` - Convert hex to CSS rgba format
- `hexAlphaToCssRgba` - Convert `#rrggbbaa` to CSS rgba format

#### `metadata` (optional)

Theme information:
- `name` - Theme display name
- `variant` - Current variant/flavor
- `accentName` - Current accent name
- `description` - Theme description

### Usage in Configurations

Programs should access theme colors via:
```nix
{config, ...}: let
  colors = config.lib.theme.colors;          # Raw colors
  semantic = config.lib.theme.semantic;     # Semantic mappings
  accent = config.lib.theme.accent;         # Current accent
  accent2 = config.lib.theme.accent2;       # Secondary accent for gradients
  accentColors = config.lib.theme.accentColors; # Available accent colors
  helpers = config.lib.theme.helpers;       # Theme helpers
in {
  # Use colors.colorname or semantic.purpose
}
```

### Theme Selection

Users select themes via:

```nix
{
  theme = {
    name = "catppuccin";     # Theme name
    variant = "mocha";       # Theme variant
    accent = "lavender";     # Accent color
  };
}
```

### System Integration (Optional)

A theme can add Home Manager settings (GTK, cursors) in `themes/themename/system.nix`.
See `themes/catppuccin/system.nix`.

### Accent Color Export

Every build writes `~/.config/theme/accent-colors.json`:

```json
{
  "theme": "catppuccin",
  "variant": "mocha",
  "currentAccent": "lavender",
  "colors": {
    "rosewater": "#f5e0dc",
    "flamingo": "#f2cdcd",
    "pink": "#f5c2e7",
    "mauve": "#cba6f7",
    "red": "#f38ba8",
    "maroon": "#eba0ac",
    "peach": "#fab387",
    "yellow": "#f9e2af",
    "green": "#a6e3a1",
    "teal": "#94e2d5",
    "sky": "#89dceb",
    "sapphire": "#74c7ec",
    "blue": "#89b4fa",
    "lavender": "#b4befe"
  }
}
```

### Adding New Themes

1. Create `themes/themename/` directory
2. Implement `themes/themename/default.nix` with required interface
3. (Optional) Add `accentColors` attribute set for accent color export
4. (Optional) Create `themes/themename/system.nix` for system integration
5. Add theme to `themes/default.nix` availableThemes
6. Add conditional system integration import if system.nix exists
7. Test with `nixos-rebuild dry-build --flake /home/sewer/nixos`