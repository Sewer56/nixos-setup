{
  config,
  lib,
  ...
}: {
  hardware.ckb-next.enable = lib.mkIf config.hostOptions.hardware.corsair.enable true;
}
