# Hardware Setup and Configuration

This document covers hardware-specific setup, configuration, and debugging for NixOS systems.

## Adding a New Machine (Host)

1. **Clone this repository into /etc/nixos/**:

   ```bash
   sudo mv /etc/nixos /etc/nixos.backup  # Backup existing config
   sudo git clone https://github.com/Sewer56/nixos-setup.git /etc/nixos
   cd /etc/nixos
   ```

2. **Create host directory**:
   ```bash
   sudo mkdir -p /etc/nixos/hosts/<hostname>
   ```

3. **Generate hardware configuration**:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   ```

4. **Create host configuration** (`hosts/<hostname>/default.nix`):

   Copy this from `hosts/laptop/default.nix` and adapt the GPU
   driver and `stateVersion` as needed.

   ```nix
   # Adapt some parts as needed
   {pkgs, ...}: {
      imports = [
        # Graphics modules (choose one):
        # ../../modules/nixos/hardware/graphics/nvidia.nix
        # ../../modules/nixos/hardware/graphics/amd.nix 
        # ../../modules/nixos/hardware/graphics/intel.nix
      ];

      system.stateVersion = "25.05";
   }
   ```

5. **Update flake.nix** to add the new host:
   ```nix
    nixosConfigurations = {
      laptop = # ... existing config
      <hostname> = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/<hostname>/default.nix
          inputs.home-manager.nixosModules.default
        ];
      };
   };
   ```

6. **Deploy the configuration**:
   ```bash
   # Use existing package versions for reproducibility
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Hardware Configuration

### Multi-GPU Systems (like laptop)

For systems with both integrated and discrete GPUs, you may need additional configuration in your host file (see `hosts/laptop/default.nix` for Prime offloading example).

## Graphics Debugging and Utilities

The graphics modules provide minimal configurations. For debugging graphics issues, use these utilities temporarily:

**OpenGL information**:
```bash
nix shell nixpkgs#glxinfo --command glxinfo | grep "OpenGL renderer"
```

**Vulkan information**:
```bash
nix shell nixpkgs#vulkan-tools --command vulkaninfo
```

**Video acceleration support**:
```bash
nix shell nixpkgs#libva-utils --command vainfo
```

**VDPAU support** (Video Decode and Presentation API for Unix - hardware-accelerated video decoding):
```bash
nix shell nixpkgs#libva-utils --command vdpauinfo
```

**GPU monitoring**:
```bash
# For NVIDIA
nix shell nixpkgs#nvtop --command nvtop

# For AMD
nix shell nixpkgs#radeontop --command radeontop

# For Intel
nix shell nixpkgs#intel-gpu-tools --command intel_gpu_top
```

## ⚠️ Non-NixOS Usage (NOT TESTED)

This configuration is designed for NixOS systems. Using the Home Manager parts on non-NixOS systems has **not been tested** and comes with significant limitations:

**Package installations will have issues** - Many GUI applications require graphics driver integration that Home Manager cannot provide on non-NixOS systems.

**Alternative approach**: Consider [nix-system-graphics](https://github.com/soupglasses/nix-system-graphics) which uses system-manager instead of Home Manager for better graphics integration, though this requires a more complex setup.

**Recommendation**: Use this configuration as reference for your own setup rather than direct deployment on non-NixOS systems.