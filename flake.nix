{
  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # NOTE: HM >= bf9ce9fe adds broken session cleanup (PropagatesStopTo=graphical-session.target
    # + exec-shutdown) that deadlocks with uwsm. Neutralized via
    # systemd.user.targets.hyprland-session.Unit.PropagatesStopTo = lib.mkForce [] in
    # users/sewer/home-manager/desktop/hyprland.nix. Revisit when upstream fixes.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # All age-encrypted secrets live in a separate private repo, so this repo
    # holds no secret material at all.
    #
    # Vendored as a git submodule at users/sewer/secrets and consumed via
    # git+file:// pointing at that submodule's working directory, exactly like
    # opencode-config below. Two reasons for git+file:// over
    # git+ssh://github.com:
    #   - `sudo nixos-rebuild` evaluates as root, and root has no SSH key or
    #     GitHub credentials, so a remote URL breaks every rebuild.
    #   - a submodule working dir is a normal git repo, so nix fetches it
    #     without needing root-level `?submodules=1` (which would also drag in
    #     opencode-source's nested submodules).
    #
    # Being a submodule means `git clone --recurse-submodules` is all that is
    # needed to bootstrap; the path is no longer an out-of-band convention.
    #
    # NOTE: editing a secret needs BOTH the submodule pointer and this input's
    # flake.lock entry bumped. hooks/pre-commit enforces that they agree.
    nixos-secrets = {
      url = "git+file:///home/sewer/nixos/users/sewer/secrets";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };

    opencode-config = {
      # Local flake owns OpenCode HM module, CLI packages, apps, and devShell.
      # Use git+file rather than root self.submodules=true so root evaluation
      # does not fetch nested opencode-source submodules.
      url = "git+file:///home/sewer/nixos/users/sewer/home-manager/programs/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.llm-agents.follows = "llm-agents";
    };

    # Hyprland ecosystem - we use hyprland's nixpkgs for cachix
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.56.1";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper/v0.8.4";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      inputs.hyprgraphics.follows = "hyprland/hyprgraphics";
      inputs.aquamarine.follows = "hyprland/aquamarine";
      inputs.systems.follows = "hyprland/systems";
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
