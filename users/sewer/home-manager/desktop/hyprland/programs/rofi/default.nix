{pkgs, ...}: {
  # Rofi configuration for NixOS/Home Manager
  # Documentation:
  # - Home Manager Rofi: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rofi.enable
  # - Rofi Configuration: https://github.com/davatorium/rofi/blob/next/doc/rofi.1.markdown#configuration
  # - Rofi Wayland: https://github.com/lbonn/rofi
  imports = [
    ./themes/default.nix
    ./bindings.nix
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      rofi-emoji
    ];

    # Set our custom theme
    theme = "./themes/applauncher/laptop.rasi";

    # Base configuration
    extraConfig = {
      modi = "drun,run,window,emoji";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "";
      display-run = "";
      display-window = "";
      display-emoji = "";
    };

    # Font configuration - commented out until system font is decided
    # font = "Iosevka Nerd Font 10";
  };
}
