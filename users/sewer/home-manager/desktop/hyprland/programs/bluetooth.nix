{
  lib,
  osConfig,
  ...
}: {
  services.blueman-applet.enable = lib.mkIf (osConfig.hardware.bluetooth.enable or false) true;
}
