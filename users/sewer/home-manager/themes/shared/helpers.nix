# Shared theme helper functions
# These utilities work across all themes and are commonly needed
{
  # Hyprland color format converters
  # Convert hex color (#rrggbb) to hyprland rgb format: rgb(rrggbb)
  hexToRgbHyprland = hex: "rgb(${builtins.substring 1 6 hex})";

  # Convert hex color (#rrggbb) to hyprland rgba format: rgba(rrggbbaa)
  # alpha is hex string (00-ff)
  hexToRgbaHyprland = hex: alpha: "rgba(${builtins.substring 1 6 hex}${alpha})";

  # Hex color manipulation helpers
  # Convert hex color to rgba with hex alpha (for CSS rgba format)
  # Input: hex="#1e1e2e", alpha="bf" -> Output: "#1e1e2ebf"
  hexToRgbaHex = hex: alpha: "${hex}${alpha}";

  # CSS rgba helper (if needed in future)
  # Convert hex color to CSS rgba format with decimal alpha (0.0-1.0)
  hexToCssRgba = hex: alpha: let
    r = toString (builtins.fromTOML "r=0x${builtins.substring 1 2 hex}").r;
    g = toString (builtins.fromTOML "g=0x${builtins.substring 3 2 hex}").g;
    b = toString (builtins.fromTOML "b=0x${builtins.substring 5 2 hex}").b;
  in "rgba(${r}, ${g}, ${b}, ${alpha})";

  # Convert hex-with-alpha format (e.g. "#1e1e2ebf") to CSS rgba
  hexAlphaToCssRgba = hexWithAlpha: let
    # Remove # prefix and extract components
    cleanHex = builtins.substring 1 8 hexWithAlpha; # Remove # and get 8 chars
    r = toString (builtins.fromTOML "r=0x${builtins.substring 0 2 cleanHex}").r;
    g = toString (builtins.fromTOML "g=0x${builtins.substring 2 2 cleanHex}").g;
    b = toString (builtins.fromTOML "b=0x${builtins.substring 4 2 cleanHex}").b;
    alphaHex = builtins.substring 6 2 cleanHex;
    # Convert hex alpha (00-ff) to decimal (0.0-1.0)
    alphaInt = (builtins.fromTOML "a=0x${alphaHex}").a;
    alphaDecimal = toString (alphaInt / 255.0);
  in "rgba(${r}, ${g}, ${b}, ${alphaDecimal})";
}
