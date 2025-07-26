{...}: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./docker.nix
    ./input.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
  ];

  hardware.enableAllFirmware = true;
}
