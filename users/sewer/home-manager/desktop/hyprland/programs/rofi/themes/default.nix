{...}: {
  # Generate shared theme files
  home.file.".config/rofi/themes/shared/colors.rasi".text = ''
    * {
        background-alt: #282839FF;
        foreground:     #D9E0EEFF;
        selected:       #7AA2F7FF;
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
