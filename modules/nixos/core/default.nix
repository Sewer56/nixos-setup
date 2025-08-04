{...}: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./docker.nix
    ./input.nix
    ./locale.nix
    ./mount.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
}
