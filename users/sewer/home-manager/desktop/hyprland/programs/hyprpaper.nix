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
}
