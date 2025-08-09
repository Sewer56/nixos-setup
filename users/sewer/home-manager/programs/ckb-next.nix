{config, ...}: {
  home.file.".config/ckb-next/ckb-next.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/users/sewer/config/corsair/k70-rgb-original.conf";
}
