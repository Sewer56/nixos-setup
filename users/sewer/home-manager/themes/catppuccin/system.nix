# Catppuccin system integration configuration
# Provides Home Manager configuration for Catppuccin theme system integration
themeConfig: pkgs:
with pkgs; let
  # TEMPORARY: Map catppuccin accent colors to magnetic-catppuccin-gtk valid accents
  # This mapping is needed because the nixpkgs version is outdated - will be removed when package is updated
  # Current package only supports: default, purple, pink, red, orange, yellow, green, teal, grey, all
  accentMapping = {
    rosewater = "pink";
    flamingo = "red";
    pink = "pink";
    mauve = "purple";
    red = "red";
    maroon = "red";
    peach = "orange";
    yellow = "yellow";
    green = "green";
    teal = "teal";
    sky = "teal";
    sapphire = "teal";
    blue = "teal";
    lavender = "teal";
  };

  # Map catppuccin variants to magnetic-catppuccin-gtk tweaks
  # mocha = default (no tweak), frappe/macchiato = respective tweaks
  variantTweaks = {
    mocha = [];
    frappe = ["frappe"];
    macchiato = ["macchiato"];
  };

  # Additional tweaks for visual customization
  extraTweaks = []; # Can add: "black", "float", "outline", "macos"

  # Combine variant tweaks with extra tweaks
  allTweaks = (variantTweaks.${themeConfig.variant} or []) ++ extraTweaks;

  # TEMPORARY: Capitalize first letter for theme name
  mappedAccent = accentMapping.${themeConfig.accent} or "purple";
  capitalizedAccent =
    (lib.toUpper (builtins.substring 0 1 mappedAccent))
    + (builtins.substring 1 (-1) mappedAccent);
in {
  # Enable Catppuccin theme globally
  catppuccin.enable = true;
  catppuccin.flavor = themeConfig.variant;
  catppuccin.accent = themeConfig.accent;

  # Disable Catppuccin rofi theme (using custom theme instead)
  catppuccin.rofi.enable = false;
  catppuccin.hyprlock.enable = false;

  # Enable Catppuccin for Cursors
  catppuccin.cursors.enable = true;

  # Configure GTK theme
  catppuccin.gtk.icon.enable = true;
  catppuccin.gtk.icon.flavor = themeConfig.variant;
  catppuccin.gtk.icon.accent = themeConfig.accent;

  gtk = {
    enable = true;
    theme = {
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = [mappedAccent];
        size = "standard";
        tweaks = allTweaks;
      };
      name = "Catppuccin-GTK-${capitalizedAccent}-Dark";
    };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
