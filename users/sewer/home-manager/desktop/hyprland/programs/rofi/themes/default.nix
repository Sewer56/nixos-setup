{config, ...}: let
  colors = config.lib.theme.colors;
  semantic = config.lib.theme.semantic;
in {
  # Rofi theme file generation for Home Manager
  # Documentation:
  # - Rofi Theming: https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown
  # - Theme Colors: Defined in theme configuration
  # - Theme Style Guide: Follow current theme conventions
  # Generate shared theme files
  # Colors follow current theme configuration
  home.file.".config/rofi/themes/shared/colors.rasi".text = ''
    * {
        /* Theme text - used for all text elements (body copy, labels) */
        text:                ${semantic.foreground}FF;

        /* Theme accent color - used for highlights, scrollbar handle, borders */
        accent:              ${semantic.accent}FF;

        /* Theme background (0x99 opacity) - main window backdrop */
        window-background:   ${semantic.background}99;

        /* Theme surface - input field background */
        search-background:   ${colors.surface1}FF;

        /* Theme border - subtle borders for input elements */
        search-border:       ${semantic.border}FF;

        /* Theme mantle - scrollbar track background */
        scrollbar-background: ${semantic.mantle}FF;

        /* Theme overlay (30% opacity) - selected item highlight */
        selection-background: ${semantic.overlay2}4D;
    }
  '';

  home.file.".config/rofi/themes/shared/fonts.rasi".text = ''
    * {
        font: "Inter 16";
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

  # Install run theme files
  home.file.".config/rofi/themes/run" = {
    source = ./run;
    recursive = true;
  };

  # Install emoji theme files
  home.file.".config/rofi/themes/emoji" = {
    source = ./emoji;
    recursive = true;
  };
}
