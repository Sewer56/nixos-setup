{config, lib, pkgs, ...}: {
  home.packages = [pkgs.vesktop];

  xdg.configFile = {
    "vesktop/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/sewer/nixos/users/sewer/home-manager/programs/vesktop/settings.json";
    };
    "vesktop/settings/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/sewer/nixos/users/sewer/home-manager/programs/vesktop/vencord-settings.json";
    };
  };
}
