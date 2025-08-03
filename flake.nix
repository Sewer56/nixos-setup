{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    # Shared modules for better IDE completion
    sharedModules = [
      inputs.home-manager.nixosModules.default
      inputs.catppuccin.nixosModules.catppuccin
    ];

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/laptop/default.nix
        inputs.home-manager.nixosModules.default
        inputs.catppuccin.nixosModules.catppuccin
        {
          nixpkgs.overlays = [
            (import ./overlays/catppuccin-papirus-folders.nix)
            inputs.rust-overlay.overlays.default
          ];
        }
      ];
    };
  };
}
