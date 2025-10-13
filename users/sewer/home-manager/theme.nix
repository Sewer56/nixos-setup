{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkMerge [
  {
    # Modular theme system
    theme = {
      name = "catppuccin";
      variant = "mocha";
      accent = "yellow";
    };

    # Configure dconf for dark theme preference
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  }

  # Import theme-specific system integration conditionally
  (
    lib.mkIf (config.theme.name == "catppuccin")
    (import ./themes/catppuccin/system.nix config.theme pkgs)
  )
]
