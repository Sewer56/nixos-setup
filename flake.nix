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
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode-flake = {
      url = "github:Sewer56/opencode-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprWorkspaceLayouts = {
      url = "github:Sewer56/hyprWorkspaceLayouts/fix-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
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

    mkSystem = hostPath:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [hostPath] ++ sharedModules;
      };
  in {
    nixosConfigurations.laptop = mkSystem ./hosts/laptop/default.nix;
    nixosConfigurations.desktop = mkSystem ./hosts/desktop/default.nix;
  };
}
