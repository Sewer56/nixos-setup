{
  pkgs,
  config,
  ...
}: {
  # Install stretchly package
  home.packages = with pkgs; [
    stretchly
  ];

  # Symlink configuration file using mkOutOfStoreSymlink
  home.file.".config/Stretchly/config.json".source = config.lib.file.mkOutOfStoreSymlink "/home/sewer/nixos/users/sewer/home-manager/programs/stretchly/config.json";
}
