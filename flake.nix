{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:Sewer56/home-manager/claude-code-extras";
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
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    sharedModules = [
      inputs.home-manager.nixosModules.default
      inputs.catppuccin.nixosModules.catppuccin
      ./hosts/shared-options.nix
      ./modules/nixos/hardware/corsair-hid.nix
      {
        nixpkgs.overlays = [
          inputs.rust-overlay.overlays.default
          (import ./overlays/default.nix)
        ];
      }
    ];

    mkSystem = hostPath: hostOptions:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs hostOptions;};
        modules = [hostPath] ++ sharedModules;
      };
  in {
    nixosConfigurations.laptop =
      mkSystem
      ./hosts/laptop/default.nix
      {
        hardware.corsair.enable = false;
        hardware.hasBattery = true;
        desktop.hyprland.ultraWideMode = false;
      };

    nixosConfigurations.desktop =
      mkSystem
      ./hosts/desktop/default.nix
      {
        hardware.corsair.enable = true;
        hardware.hasBattery = false;
        desktop.hyprland.ultraWideMode = true;
      };
  };
}
