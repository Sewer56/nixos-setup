# Hardware Setup and Configuration

## Adding a New Machine (Host)

1. **Clone this repository into /home/sewer/nixos/**:

   ```bash
   sudo mv /etc/nixos /etc/nixos.backup  # Backup existing config
   git clone --recurse-submodules https://github.com/Sewer56/nixos-setup.git /home/sewer/nixos
   cd /home/sewer/nixos
   git config core.hooksPath hooks
   ```

2. **Set up secrets access**: see [SECRETS.md](SECRETS.md#setup-for-new-machine).

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

7. **Stage the new files**. Flakes only see git-tracked files, so an unstaged
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

Open the printed URL to log in.

### Proton Mail Setup

Proton Mail may crash on its first Wayland launch.

Run it once under X11:

```bash
XDG_SESSION_TYPE=x11 proton-mail
```

After that it runs fine on Wayland.

## Hardware Configuration

### Multi-GPU Systems (like laptop)

Nvidia + Intel hybrid setups may need PRIME settings; see `hosts/laptop/default.nix`.

## Monitor Configuration

### Hyprland Monitor Setup

Home Manager creates an empty `~/.config/hypr/monitors.lua` if it doesn't exist.

Edit it with `nwg-displays`, or by hand with `hl.monitor({ ... })` calls.
It's kept outside Nix so you can change monitors without a rebuild.

## Graphics Debugging and Utilities

Run these on demand when debugging graphics:

**OpenGL information**:
```bash
nix shell nixpkgs#mesa-demos --command glxinfo | grep "OpenGL renderer"
```

**Vulkan information**:
```bash
nix shell nixpkgs#vulkan-tools --command vulkaninfo
```

**Video acceleration support**:
```bash
nix shell nixpkgs#libva-utils --command vainfo
```

**VDPAU support** (Video Decode and Presentation API for Unix):
```bash
nix shell nixpkgs#vdpauinfo --command vdpauinfo
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

The Home Manager parts have **not been tested** outside NixOS.

Many GUI apps may fail there, because Home Manager can't set up graphics drivers.
[nix-system-graphics](https://github.com/soupglasses/nix-system-graphics) can fill that gap.