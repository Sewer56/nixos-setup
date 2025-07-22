{pkgs, ...}: let
  theme = import ./theme.nix;
  bars = import ./bars.nix;
  workspaces = import ./modules/workspaces.nix;
  system = import ./modules/system.nix;
  audio = import ./modules/audio.nix;
  network = import ./modules/network.nix;
  bluetooth = import ./modules/bluetooth.nix;
  battery = import ./modules/battery/battery.nix;
  clock = import ./modules/clock.nix;
  tray = import ./modules/tray.nix;
  backlight = import ./modules/backlight.nix;
  custom = import ./modules/custom.nix;
in {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.waybar = {
    enable = true;
    settings = [
      (bars.indicatorBar
        // {
          battery = battery.config.battery;
        })
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
        // custom.config
      )
    ];
    style = ''
      ${theme.baseStyle}
      ${theme.moduleBaseStyle}
      ${theme.criticalAnimationStyle}
      ${theme.chargingAnimationStyle}
      ${bars.indicatorBarStyle}
      ${workspaces.style}
      ${system.style}
      ${audio.style}
      ${network.style}
      ${bluetooth.style}
      ${battery.style}
      ${clock.style}
      ${tray.style}
      ${backlight.style}
      ${custom.style}
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
  };
}
