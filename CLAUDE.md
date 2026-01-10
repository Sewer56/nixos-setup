# CLAUDE.md

This is a modular NixOS configuration using flakes with clear separation between system and user concerns.

## Directory Structure

- `hosts/` - Machine-specific configurations (`laptop`, `desktop`)
- `modules/nixos/` - System-level modules organized by purpose:
  - `core/` - Essential system modules (audio, networking, locale, packages, security, tailscale)
  - `desktop/` - Desktop environment modules (hyprland, sddm)
  - `hardware/` - Hardware-specific modules for different GPU drivers
- `users/sewer/` - User configuration with dual structure:
  - `nixos/` - NixOS-specific user settings (account, groups)
  - `home-manager/` - Portable user configuration managed by Home Manager

### Key Architecture Principles

- **User/System Separation**: System config in `/modules/nixos/`, user config in `/users/sewer/home-manager/`
- **Home Manager Integration**: User packages and dotfiles managed through Home Manager
- **Flake-based**: All dependencies locked for reproducibility

### Formatting Rules

When importing, always give the full path e.g. `rofi/default.nix` instead of `rofi/`.

## Development Workflow

### Adding User Packages

1. Edit `users/sewer/home-manager/packages.nix` for simple package additions
2. Create new file in `users/sewer/home-manager/programs/` when a package is configurable (check `home-manager` using MCP server)
3. Add desktop-specific packages to `users/sewer/home-manager/desktop/`.

Always prefer to use `programs.<name>` when available for installing packages.

### Adding System Packages

- Edit `modules/nixos/core/packages.nix` for system-wide packages

### Theme Management

- Catppuccin theme is configured globally in Home Manager
- Theme settings in `users/sewer/home-manager/desktop/hyprland/theme.nix`

## Validation Steps

After making changes, follow these steps to validate:

1. **Stage Changes**: Stage all files which previously have not existed. This is required by flakes. Do not stage existing files.
2. **Test Configuration**: Run `nixos-rebuild dry-build --flake /home/sewer/nixos` to validate changes without applying them.
3. **Format All Files**: Run `alejandra *` to format all files.
4. **Executable Scripts**: Ensure all scripts files are executable by running `chmod +x` on them.

If the dry build does not pass, any new added files will need to be staged.