{lib, ...}: {
  options.hostOptions = {
    hardware.corsair.enable = lib.mkEnableOption "Corsair ckb-next support";
    hardware.hasBattery = lib.mkEnableOption "this device is battery powered";

    desktop.hyprland = {
      ultraWideMode = lib.mkEnableOption "ultrawide (32:9) display-specific Hyprland settings";
    };
  };
}
