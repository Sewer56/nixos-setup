{
  config,
  inputs,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      ipc = "on";
      splash = false;
    };
  };

  # Wallpaper autostart is in lua/autostart.lua (startup-wrapper, sync scripts,
  # cursor theme rewire)
}
