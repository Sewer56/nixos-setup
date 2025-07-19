# Sewer's Personal NixOS Configuration

> [!NOTE]
> I'm new to Nix, so this is my personal learning repository and might not follow best practices everywhere.

My personal NixOS configuration using flakes with modular architecture
and separated system/user concerns.

Reproduces my laptop setup and installs to `/etc/nixos` as usual.

## Directory Structure & Architecture

### System-Level Configuration
```
/etc/nixos/
├── flake.nix                   # Main flake definition with system configurations
├── flake.lock                  # Locked dependency versions
├── hosts/                      # Machine-specific configurations
└── modules/nixos/              # System-level modules
    ├── core/                   # Essential NixOS modules (audio, networking, locale)
    ├── desktop/                # Desktop environment modules (e.g. window-managers, display-managers)
    └── hardware/               # Hardware-specific modules (e.g. AMD/Intel/Nvidia GPU)
```

### User-Level Configuration
```
└── users/sewer/                # User configuration
    ├── nixos/                  # NixOS-specific user settings
    └── home-manager/           # Portable user configuration
        ├── packages.nix        # User packages
        ├── shell.nix           # Shell configuration
        └── desktop/            # User desktop configuration
```

## Daily Usage

### Applying Changes

**Test changes before applying**:
```bash
sudo nixos-rebuild test --flake .  # Temporary activation
sudo nixos-rebuild boot --flake .  # Apply on next reboot
```

**Apply (commit) update**:
```bash
sudo nixos-rebuild switch --flake .
```

### Installing a Program (User)

Edit `users/sewer/home-manager/packages.nix`

- Move to `users/sewer/home-manager/programs/` if the program has custom configuration
- Move to `users/sewer/home-manager/desktop/` if the program is part of the core desktop environment

### Updating System Packages

All software versions are fixed/locked until the flake is updated,

```bash
sudo nix flake update
```

Or can be done as part of updating:

```bash
sudo nixos-rebuild switch --flake . --upgrade
```

## System Maintenance

### Rollback
```bash
sudo nixos-rebuild rollback
```

### Garbage Collection

```bash
# Delete ALL old generations and unreferenced packages
sudo nix-collect-garbage -d
```

```bash
# Delete everything older than 7 days
sudo nix-collect-garbage --delete-older-than 7d
```

## Setting Up for New Machines

For hardware setup, configuration, and debugging, see [HARDWARE.md](HARDWARE.md).

---

## ⚠️ Non-NixOS Usage (NOT TESTED)

See [HARDWARE.md](HARDWARE.md#️-non-nixos-usage-not-tested) for information about using this configuration on non-NixOS systems.