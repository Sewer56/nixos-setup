{...}: {
  # Install shared theme files
  home.file.".config/rofi/themes/shared" = {
    source = ./shared;
    recursive = true;
  };

  # Install applauncher theme files
  home.file.".config/rofi/themes/applauncher" = {
    source = ./applauncher;
    recursive = true;
  };

  # Install clipboard theme files
  home.file.".config/rofi/themes/clipboard" = {
    source = ./clipboard;
    recursive = true;
  };

  # Color schemes
  home.file.".config/rofi/colors/catppuccin.rasi".text = ''
    /**
     * Catppuccin Mocha color scheme for Rofi
     * Adapted to match the system theme
     **/

    * {
        background:     #1E1D2FFF;
        background-alt: #282839FF;
        foreground:     #D9E0EEFF;
        selected:       #7AA2F7FF;
        active:         #ABE9B3FF;
        urgent:         #F28FADFF;
    }
  '';
}
