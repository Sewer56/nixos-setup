{inputs, ...}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  # Enable Catppuccin theme globally
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "lavender";

  # This is technically deprecated.
  catppuccin.gtk.enable = true;
  catppuccin.gtk.icon.enable = true;
  catppuccin.gtk.icon.flavor = "mocha";
  catppuccin.gtk.icon.accent = "lavender";

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
