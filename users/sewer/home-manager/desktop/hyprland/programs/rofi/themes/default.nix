{config, ...}: let
  colors = config.lib.catppuccin.colors;
  accentColor = colors.${config.catppuccin.accent};
in {
  # Generate shared theme files
  # Colors follow Catppuccin style guide: https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
  home.file.".config/rofi/themes/shared/colors.rasi".text = ''
    * {
        /* Catppuccin Text - used for all text elements (body copy, labels) */
        text:                ${colors.text}FF;

        /* User accent color - used for highlights, scrollbar handle, borders */
        accent:              ${accentColor}FF;

        /* Catppuccin Base (0x99 opacity) - main window backdrop */
        window-background:   ${colors.base}99;

        /* Catppuccin Surface1 - input field background */
        search-background:   ${colors.surface1}FF;

        /* Catppuccin Overlay0 - subtle borders for input elements */
        search-border:       ${colors.overlay0}FF;

        /* Catppuccin Mantle - scrollbar track background */
        scrollbar-background: ${colors.mantle}FF;

        /* Catppuccin Overlay2 (30% opacity) - selected item highlight */
        selection-background: ${colors.overlay2}4D;
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
