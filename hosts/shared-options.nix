{lib, ...}: {
  options.hostOptions = {
    hardware.corsair.enable = lib.mkEnableOption "Corsair ckb-next support";
    hardware.hasBattery = lib.mkEnableOption "this device is battery powered";

    desktop.hyprland = {
      displayMode = lib.mkOption {
        type = lib.types.enum ["single" "ultrawide" "threeScreens"];
        default = "single";
        description = "Display mode configuration for Hyprland workspaces and window management";
      };
      preferDedicatedLaptopGpu = lib.mkEnableOption "Use dedicated GPU (card1) for Hyprland rendering on laptop";
    };
  };
}
