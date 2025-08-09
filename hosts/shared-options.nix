{lib, ...}: {
  options.hostOptions = {
    hardware.corsair.enable = lib.mkEnableOption "Corsair ckb-next support";
    
    desktop.hyprland = {
      ultraWideMode = lib.mkEnableOption "ultrawide (32:9) display-specific Hyprland settings";
    };
  };
}