{pkgs, ...}: let
  theme = import ./theme.nix;
  bars = import ./bars.nix;
  workspaces = import ./modules/workspaces.nix;
  system = import ./modules/system.nix;
  audio = import ./modules/audio.nix;
  network = import ./modules/network.nix;
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
  };
}
