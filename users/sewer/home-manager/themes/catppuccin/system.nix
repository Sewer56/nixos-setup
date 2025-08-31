# Catppuccin system integration configuration
# Provides Home Manager configuration for Catppuccin theme system integration
themeConfig: pkgs:
with pkgs; let
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

  # Construct GTK theme name based on configuration
  # Format: Catppuccin-[Accent]-[Light/Dark]-[Variant]
  capitalizedAccent =
    lib.strings.toUpper (lib.strings.substring 0 1 themeConfig.accent)
    + lib.strings.substring 1 (-1) themeConfig.accent;
  variantSuffix =
    if themeConfig.variant == "mocha"
    then ""
    else if themeConfig.variant == "frappe"
    then "-Frappe"
    else if themeConfig.variant == "macchiato"
    then "-Macchiato"
    else "";
  gtkThemeName = "Catppuccin-${capitalizedAccent}-Dark${variantSuffix}";
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
        themeName = "Catppuccin";
        accent = [themeConfig.accent];
        tweaks = allTweaks;
      };
      name = gtkThemeName;
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
