# Catppuccin system integration configuration
# Provides Home Manager configuration for Catppuccin theme system integration
themeConfig: pkgs:
let
  # Map catppuccin variants to magnetic-catppuccin-gtk tweaks
  # mocha = default (no tweak), frappe/macchiato = respective tweaks
  variantTweaks = {
    mocha = [];
    frappe = [ "frappe" ];
    macchiato = [ "macchiato" ];
  };
  
  # Additional tweaks for visual customization
  extraTweaks = []; # Can add: "black", "float", "outline", "macos"
  
  # Combine variant tweaks with extra tweaks
  allTweaks = (variantTweaks.${themeConfig.variant} or []) ++ extraTweaks;
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
        accent = ["all"]; # TODO: Use themeConfig.accent when accent mapping is resolved
        size = "standard";
        tweaks = allTweaks;
      };
      name = "Catppuccin-GTK-Dark";
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
