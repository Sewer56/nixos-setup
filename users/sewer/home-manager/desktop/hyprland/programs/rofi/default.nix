{pkgs, ...}: {
  imports = [
    ./themes/default.nix
    ./bindings.nix
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    # Set our custom theme
    theme = "./themes/applauncher/laptop.rasi";

    # Base configuration
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "";
      display-run = "";
      display-window = "";
    };

    # Font configuration - commented out until system font is decided
    # font = "Iosevka Nerd Font 10";
  };
}
