{...}: {
  # Enable Flakes and nix commands
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;
}
