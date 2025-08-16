# Catppuccin system integration configuration
# Provides Home Manager configuration for Catppuccin theme system integration
themeConfig: {
  # Enable Catppuccin theme globally
  catppuccin.enable = true;
  catppuccin.flavor = themeConfig.variant;
  catppuccin.accent = themeConfig.accent;

  # Disable Catppuccin rofi theme (using custom theme instead)
  catppuccin.rofi.enable = false;
  catppuccin.hyprlock.enable = false;

  # Enable Catppuccin for Cursors
  catppuccin.cursors.enable = true;

  # This is technically deprecated.
  catppuccin.gtk.enable = false;
  catppuccin.gtk.icon.enable = true;
  catppuccin.gtk.icon.flavor = themeConfig.variant;
  catppuccin.gtk.icon.accent = themeConfig.accent;

  gtk = {
    enable = true;
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
