{
  config,
  pkgs,
  ...
}: let
  semantic = config.lib.theme.semantic;
  theme = import ./theme.nix semantic;
  bars = import ./bars.nix semantic;
  workspaces = import ./modules/workspaces.nix semantic;
  system = import ./modules/system.nix semantic;
  audio = import ./modules/audio.nix semantic;
  network = import ./modules/network.nix semantic;
  bluetooth = import ./modules/bluetooth.nix semantic;
  battery = import ./modules/battery/battery.nix semantic;
  clock = import ./modules/clock.nix semantic;
  tray = import ./modules/tray.nix;
  backlight = import ./modules/backlight.nix semantic;
  spacers = import ./modules/spacers.nix semantic;
  visualizer = import ./modules/visualizer.nix semantic;
  uptime = import ./modules/uptime.nix semantic;
  wallpaper = import ./modules/wallpaper.nix semantic;
in {
  imports = [
    ./scripts/wallpaper/packages.nix
  ];
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
        // wallpaper.config
      )
      (
        bars.bottomBar
        // workspaces.config
        // spacers.config
      )
    ];
    style = ''
      ${theme.baseStyle}
      ${theme.moduleBaseStyle}
      ${theme.criticalAnimationStyle}
      ${theme.chargingAnimationStyle}

      ${bars.mainBarStyle}
      ${bars.bottomBarStyle}
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
      ${wallpaper.style}
    '';
  };

  home.file."Pictures/wallpapers/monitor_state.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/users/sewer/home-manager/desktop/hyprland/programs/waybar/scripts/wallpaper/state/monitor_state.json";
  home.file."Pictures/wallpapers/wallpaper_collection.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/users/sewer/home-manager/desktop/hyprland/programs/waybar/scripts/wallpaper/state/wallpaper_collection.json";

  xdg.configFile = {
    "waybar/modules/battery/bat-pp.sh" = {
      source = ./modules/battery/bat-pp.sh;
      executable = true;
    };
    "waybar/scripts" = {
      source = ./scripts;
      recursive = true;
      # Note: Executable does not work on folders.
      # Remember to chmod +x
    };
  };
}
