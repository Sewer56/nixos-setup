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
  wallpaper = import ./modules/wallpaper.nix theme;
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
        // wallpaper.config
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
