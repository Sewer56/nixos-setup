{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.ckb-next = {
    enable = lib.mkIf config.hostOptions.hardware.corsair.enable true;
    package = pkgs.ckb-next.overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or []) ++ ["-DUSE_DBUS_MENU=0"];
    });
  };
}
