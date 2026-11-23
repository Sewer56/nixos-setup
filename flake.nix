{
  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # HM >= bf9ce9fe deadlocks uwsm on session stop.
    # Worked around in users/sewer/home-manager/desktop/hyprland.nix; revisit when upstream fixes it.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Private secrets repo @ users/sewer/secrets .
    #
    # git+file because `sudo nixos-rebuild` runs as root, which has no GitHub SSH key.
    #
    # Bump both submodule and flake.lock when adding a secret.
    nixos-secrets = {
      url = "git+file:///home/sewer/nixos/users/sewer/secrets";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-config = {
      # Local flake with the OpenCode HM module and CLI tools.
      #
      # git+file instead of `self.submodules = true`, to keep evaluation fast
      # and avoid unneeded recursive copies.
      url = "git+file:///home/sewer/nixos/users/sewer/home-manager/programs/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.llm-agents.follows = "llm-agents";
    };

    # Hyprland ecosystem - using hyprland's nixpkgs for cachix
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.57.2";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper/v0.8.5";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      inputs.hyprgraphics.follows = "hyprland/hyprgraphics";
      inputs.aquamarine.follows = "hyprland/aquamarine";
      inputs.hyprwire.follows = "hyprland/hyprwire";
      inputs.hyprtoolkit.follows = "hyprland/hyprtoolkit";
      inputs.systems.follows = "hyprland/systems";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # No binaries, so not following nixpkgs keeps cache hits.
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
