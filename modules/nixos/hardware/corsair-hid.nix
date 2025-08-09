{hostOptions, lib, ...}: {
  hardware.ckb-next.enable = lib.mkIf hostOptions.hardware.corsair.enable true;
}
