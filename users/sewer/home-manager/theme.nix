{
  config,
  lib,
  ...
}:
lib.mkMerge [
  {
    # Modular theme system
    theme = {
      name = "catppuccin";
      variant = "mocha";
      accent = "lavender";
    };
  }

  # Import theme-specific system integration conditionally
  (
    lib.mkIf (config.theme.name == "catppuccin")
    (import ./themes/catppuccin/system.nix config.theme)
  )
]
