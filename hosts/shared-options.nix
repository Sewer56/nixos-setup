{lib, ...}: {
  options.hostOptions = {
    hardware.corsair.enable = lib.mkEnableOption "Corsair ckb-next support";
    hardware.hasBattery = lib.mkEnableOption "this device is battery powered";
    hardware.nvidia.driverVersion = lib.mkOption {
      type = lib.types.enum ["stable" "beta" "production" "vulkan_beta" "legacy_470" "legacy_390"];
      default = "stable";
      description = "NVIDIA driver version to use (stable, beta, production, vulkan_beta, legacy_470, legacy_390)";
    };
    nas.enable = lib.mkEnableOption "NAS NFS mounts";

    desktop.hyprland = {
      displayMode = lib.mkOption {
        type = lib.types.enum ["single" "ultrawide" "threeScreens"];
        default = "single";
        description = "Display mode configuration for Hyprland workspaces and window management";
      };
      preferDedicatedLaptopGpu = lib.mkEnableOption "Use dedicated GPU (card1) for Hyprland rendering on laptop";
    };

    theme.accent = lib.mkOption {
      type = lib.types.str;
      default = "lavender";
      description = "Theme accent color name for this host (must be valid for the selected theme)";
    };
  };
}
