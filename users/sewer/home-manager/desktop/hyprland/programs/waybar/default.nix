{
  config,
  pkgs,
  ...
}: let
  catppuccin = config.lib.catppuccin.colors;
  theme = import ./theme.nix catppuccin;
  bars = import ./bars.nix theme;
  workspaces = import ./modules/workspaces.nix theme;
  system = import ./modules/system.nix theme;
  audio = import ./modules/audio.nix theme;
  network = import ./modules/network.nix theme;
  bluetooth = import ./modules/bluetooth.nix theme;
  battery = import ./modules/battery/battery.nix theme;
  clock = import ./modules/clock.nix theme;
  tray = import ./modules/tray.nix;
  backlight = import ./modules/backlight.nix theme;
  spacers = import ./modules/spacers.nix theme;
  visualizer = import ./modules/visualizer.nix theme;
  uptime = import ./modules/uptime.nix theme;
in {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # For Visualizer
  programs.cava.enable = true;

  programs.waybar = {
    enable = true;
    settings = [
      (
        bars.mainBar
        // workspaces.config
        // system.config
        // audio.config
        // network.config
        // bluetooth.config
        // battery.config
        // clock.config
        // tray.config
        // backlight.config
        // spacers.config
        // visualizer.config
        // uptime.config
      )
    ];
    style = ''
      ${theme.baseStyle}
      ${theme.moduleBaseStyle}
      ${theme.criticalAnimationStyle}
      ${theme.chargingAnimationStyle}
      ${bars.mainBarStyle}
      ${workspaces.style}
      ${system.style}
      ${audio.style}
      ${network.style}
      ${bluetooth.style}
      ${battery.style}
      ${clock.style}
      ${tray.style}
      ${backlight.style}
      ${spacers.style}
      ${visualizer.style}
      ${uptime.style}
    '';
  };

  xdg.configFile = {
    "waybar/modules/battery/bat-pp.sh" = {
      source = ./modules/battery/bat-pp.sh;
      executable = true;
    };
    "waybar/scripts/audio-input-volume-up.sh" = {
      source = ./scripts/audio-input-volume-up.sh;
      executable = true;
    };
    "waybar/scripts/audio-input-volume-down.sh" = {
      source = ./scripts/audio-input-volume-down.sh;
      executable = true;
    };
    "waybar/scripts/launch-audio-control.sh" = {
      source = ./scripts/launch-audio-control.sh;
      executable = true;
    };
    "waybar/scripts/launch-calendar.sh" = {
      source = ./scripts/launch-calendar.sh;
      executable = true;
    };
    "waybar/scripts/launch-wifi-manager.sh" = {
      source = ./scripts/launch-wifi-manager.sh;
      executable = true;
    };
    "waybar/scripts/launch-disk-analyzer.sh" = {
      source = ./scripts/launch-disk-analyzer.sh;
      executable = true;
    };
    "waybar/scripts/launch-bluetooth-manager.sh" = {
      source = ./scripts/launch-bluetooth-manager.sh;
      executable = true;
    };
    "waybar/scripts/uptime-since-resume.sh" = {
      source = ./scripts/uptime-since-resume.sh;
      executable = true;
    };
  };
}
