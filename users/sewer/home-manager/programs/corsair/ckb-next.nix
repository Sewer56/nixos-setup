{
  config,
  hostOptions,
  lib,
  ...
}: {
  config = lib.mkIf hostOptions.hardware.corsair.enable {
    home.file.".config/ckb-next/ckb-next.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/users/sewer/home-manager/programs/corsair/k70-rgb-original.conf";

    # In on hyprland, add to autoexecute.
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "ckb-next -b"
      ];
    };
  };
}
