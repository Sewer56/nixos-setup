{...}: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./cachix.nix
    ./docker.nix
    ./input.nix
    ./locale.nix
    ./mount.nix
    ./networking.nix
    ./nfs-mounts.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
}
