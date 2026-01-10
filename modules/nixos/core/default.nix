{...}: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./cachix.nix
    ./cdemu.nix
    ./docker.nix
    ./input.nix
    ./locale.nix
    ./mount.nix
    ./networking.nix
    ./nfs-mounts.nix
    ./nix.nix
    ./packages.nix
    ./printing.nix
    ./security.nix
    ./tailscale.nix
    ./virt-manager.nix
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
}
