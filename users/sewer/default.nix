# User Module for Me (sewer)
# This is the NixOS entry point that combines:
# - NixOS-specific user configuration (./nixos/)
# - Portable home-manager configuration (./home-manager/)
{
  inputs,
  config,
  ...
}: {
  imports = [
    # NixOS-specific user settings (user account, groups, etc.)
    inputs.agenix.nixosModules.default
    ./nixos/default.nix

    # Import home-manager module
    inputs.home-manager.nixosModules.default
  ];

  # At boot, dconf can start GVFS on a temporary D-Bus session.
  # When that session ends, GVFS can crash and leave ~/.gvfs inaccessible.
  systemd.services.home-manager-sewer.environment.GIO_USE_VFS = "local";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # Shared modules for better IDE completion
    sharedModules = [
      inputs.agenix.homeManagerModules.default
      inputs.catppuccin.homeModules.catppuccin
    ];

    # also pass inputs and hostOptions to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
      hostOptions = config.hostOptions;
    };
    users = {
      "sewer" = import ./home-manager/default.nix;
    };
  };
}
