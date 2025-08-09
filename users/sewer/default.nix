# User Module for Me (sewer)
# This is the NixOS entry point that combines:
# - NixOS-specific user configuration (./nixos/)
# - Portable home-manager configuration (./home-manager/)
{inputs, ...}: {
  imports = [
    # NixOS-specific user settings (user account, groups, etc.)
    ./nixos/default.nix

    # Import home-manager module
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # Shared modules for better IDE completion
    sharedModules = [
      inputs.agenix.homeManagerModules.default
      inputs.catppuccin.homeModules.catppuccin
      inputs.claude-code-nix-flake.homeManagerModules.claude-code
    ];

    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "sewer" = import ./home-manager/default.nix;
    };
  };
}
