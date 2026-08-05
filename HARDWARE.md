# Hardware Setup and Configuration

This document covers hardware-specific setup, configuration, and debugging for NixOS systems.

## Adding a New Machine (Host)

1. **Clone this repository into /home/sewer/nixos/**:

   ```bash
   sudo mv /etc/nixos /etc/nixos.backup  # Backup existing config
   git clone --recurse-submodules https://github.com/Sewer56/nixos-setup.git /home/sewer/nixos
   cd /home/sewer/nixos
   git config core.hooksPath hooks
   ```

2. **Set up secrets access** — see [SECRETS.md](SECRETS.md#setup-for-new-machine).

3. **Create host directory**:
   ```bash
   mkdir -p /home/sewer/nixos/hosts/<hostname>
   ```

4. **Generate hardware configuration**:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   ```

5. **Create host configuration** (`hosts/<hostname>/default.nix`):

   Copy `hosts/laptop/default.nix` and adapt the GPU driver and
   `stateVersion` as needed.

   ```bash
   cp hosts/laptop/default.nix hosts/<hostname>/default.nix
   ```

   The parts to review:

   ```nix
   {pkgs, lib, ...}: {
      imports = [
        ./hardware-configuration.nix
        ../../modules/nixos/core/default.nix
        ../../modules/nixos/desktop/default.nix
        ../../users/sewer/default.nix
        # Graphics modules (choose one):
        # ../../modules/nixos/hardware/graphics/nvidia.nix
        # ../../modules/nixos/hardware/graphics/amd.nix
        # ../../modules/nixos/hardware/graphics/intel.nix
      ];

      # See hosts/shared-options.nix for the full set
      hostOptions = { /* ... */ };

      networking.hostName = "<hostname>";
      system.stateVersion = "25.05";
   }
   ```

6. **Update flake.nix** to add the new host via `mkSystem`:
   ```nix
   nixosConfigurations.laptop = mkSystem ./hosts/laptop/default.nix;
   nixosConfigurations.desktop = mkSystem ./hosts/desktop/default.nix;
   nixosConfigurations.<hostname> = mkSystem ./hosts/<hostname>/default.nix;
   ```

7. **Stage the new files** — flakes only see git-tracked files, so an unstaged
   host directory fails with "not tracked by Git":
   ```bash
   git add hosts/<hostname>
   ```

8. **Deploy the configuration**:
   ```bash
   # Use existing package versions for reproducibility
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Manual Steps (New Machine Setup Only)

*Personal instructions only - ignore if not applicable to you.*

### Tailscale VPN Setup

Tailscale is enabled system-wide (`modules/nixos/core/tailscale.nix`) but requires one-time authentication per device:

```bash
sudo tailscale up
```

Follow the URL printed to authenticate in your browser. The authentication state persists in `/var/lib/tailscale` across rebuilds.

**Note**: Auth keys are not used because they expire after 90 days, and regenerating them via the Tailscale website is more hassle than manual authentication.

### Proton Mail Setup

Proton Mail may crash on first boot with Wayland, run with X11 at least once:

```bash
XDG_SESSION_TYPE=x11 proton-mail
```

Future invocations will run successfully on wayland.

## Hardware Configuration

### Multi-GPU Systems (like laptop)

For systems with both integrated and discrete GPUs, you may need additional configuration in your host file (see `hosts/laptop/default.nix` for Prime offloading example).

## Monitor Configuration

### Hyprland Monitor Setup

The system automatically creates an empty `~/.config/hypr/monitors.lua` file during home-manager activation if it doesn't exist when using hyprland.

Use `nwg-displays` to modify this (or edit `monitors.lua` directly with `hl.monitor({ ... })` calls).
This is made non-declarative to allow for manual adjustments on the fly, e.g. without needing to rebuild the entire system configuration.

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