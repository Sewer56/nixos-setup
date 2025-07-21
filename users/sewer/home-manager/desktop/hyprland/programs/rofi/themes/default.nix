{config, ...}: let
  colors = config.lib.catppuccin.colors;
  accentColor = colors.${config.catppuccin.accent};
in {
  # Generate shared theme files
  home.file.".config/rofi/themes/shared/colors.rasi".text = ''
    * {
        background-alt:      ${colors.mantle}FF;
        foreground:          ${colors.text}FF;
        selected:            ${accentColor}FF;
        background-dark:     ${colors.base}99;
        border-subtle:       ${colors.overlay0}FF;
        background-input:    ${colors.surface1}FF;
        background-selected: ${colors.overlay2}4D;
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
