{
  lib,
  osConfig,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf (osConfig.hardware.bluetooth.enable or false) [
    pkgs.overskride
  ];
}
