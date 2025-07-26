{
  inputs,
  config,
  ...
}: {
  # Enable Catppuccin theme globally
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "lavender";

  # Disable Catppuccin rofi theme (using custom theme instead)
  catppuccin.rofi.enable = false;
  catppuccin.hyprlock.enable = false;

  # Enable Catppuccin for Cursors
  catppuccin.cursors.enable = true;
  home.sessionVariables = {
    HYPRCURSOR_SIZE = config.home.pointerCursor.size;
    HYPRCURSOR_THEME = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-cursors";
  };

  # This is technically deprecated.
  catppuccin.gtk.enable = true;
  catppuccin.gtk.icon.enable = true;
  catppuccin.gtk.icon.flavor = config.catppuccin.flavor;
  catppuccin.gtk.icon.accent = config.catppuccin.accent;

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
