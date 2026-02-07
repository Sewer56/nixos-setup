{
  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland ecosystem - we use hyprland's nixpkgs for cachix
    hyprgraphics = {
      url = "github:hyprwm/hyprgraphics/v0.5.0";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.systems.follows = "hyprland/systems";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.53.1";
      inputs.hyprgraphics.follows = "hyprgraphics";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper/v0.8.1";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      inputs.systems.follows = "hyprland/systems";
    };
    hyprWorkspaceLayouts = {
      url = "github:zakk4223/hyprWorkspaceLayouts";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # Catppuccin is a theme, we have no binary dependencies, so don't follow nixpkgs for the
    # purposes of better caching.
    catppuccin.url = "github:catppuccin/nix";
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
