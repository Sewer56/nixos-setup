{config, ...}: let
  colors = config.lib.catppuccin.colors;
  accentColor = colors.${config.catppuccin.accent};
in {
  # Generate shared theme files
  home.file.".config/rofi/themes/shared/colors.rasi".text = ''
    * {
        background-alt:      #282839FF;
        foreground:          #D9E0EEFF;
        selected:            ${accentColor}FF;
        background-dark:     black / 60%;
        background-medium:   black / 40%;
        background-light:    black / 10%;
        border-subtle:       white / 25%;
        background-input:    white / 5%;
        background-selected: white / 15%;
    }
  '';

  home.file.".config/rofi/themes/shared/fonts.rasi".text = ''
    * {
        /* font: "Iosevka Nerd Font 10"; */
        /* Font configuration commented out until system font is decided */
    }
  '';

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
}
