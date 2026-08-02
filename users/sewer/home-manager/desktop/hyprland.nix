{
  pkgs,
  inputs,
  lib,
  config,
  hostOptions,
  ...
}: let
  # Substitute placeholders in a Lua template (store paths, theme colors).
  substitute = replacements: path:
    builtins.replaceStrings (builtins.attrNames replacements) (builtins.attrValues replacements) (builtins.readFile path);

  helpers = config.lib.theme.helpers;

  layoutToggle = pkgs.writeShellScript "layout-toggle" ''
    WS_ID=$(hyprctl activeworkspace -j | jq -r .id)
    CURRENT=$(hyprctl activeworkspace -j | jq -r .tiledLayout)

    if [ "$CURRENT" = "master" ]; then
      hyprctl eval "hl.workspace_rule({ workspace = \"$WS_ID\", layout = \"dwindle\" })"
      notify-send -t 1500 "Layout" "Workspace $WS_ID: dwindle"
    else
      hyprctl eval "hl.workspace_rule({ workspace = \"$WS_ID\", layout = \"master\" })"
      notify-send -t 1500 "Layout" "Workspace $WS_ID: master"
    fi
  '';

  touchpadToggle = pkgs.writeShellScript "touchpad-toggle" ''
    #!/usr/bin/env bash

    # Touchpad toggle script for Hyprland
    # Toggles the touchpad on/off using hyprctl

    # Find the touchpad device name
    TOUCHPAD=$(hyprctl devices | grep touchpad | sed "s/^[[:space:]]*//")

    if [ -z "$TOUCHPAD" ]; then
        echo "No touchpad found"
        exit 1
    fi

    # State file to track touchpad status
    STATE_FILE="/tmp/touchpad_enabled"

    # Toggle touchpad based on state file
    if [ -f "$STATE_FILE" ]; then
        # Touchpad is currently disabled, enable it
        hyprctl eval "hl.device({ name = \"$TOUCHPAD\", enabled = true })"
        rm "$STATE_FILE"
        echo "Touchpad enabled"
    else
        # Touchpad is currently enabled, disable it
        hyprctl eval "hl.device({ name = \"$TOUCHPAD\", enabled = false })"
        touch "$STATE_FILE"
        echo "Touchpad disabled"
    fi
  '';

  # Display-mode-specific workspace/window rules
  rulesFile =
    if hostOptions.desktop.hyprland.displayMode == "ultrawide"
    then ./hyprland/lua/rules-ultrawide.lua
    else if hostOptions.desktop.hyprland.displayMode == "threeScreens"
    then ./hyprland/lua/rules-threescreens.lua
    else ./hyprland/lua/rules-single.lua;
in {
  imports = [
    ./hyprland/default.nix
  ];

  # Enable Wayland support for Chrome/Chromium-based applications
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Packages required by hyprland bindings (lua/binds.lua)
  home.packages = with pkgs; [
    playerctl # Music controls
    killall # Waybar toggle binding
  ];

  # Hyprland Window Manager (User Configuration)
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    configType = "lua";
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };

    # Real Lua config files, written under ~/.config/hypr and auto-required.
    # Placeholders (@...@) are substituted from Nix (store paths, theme colors).
    extraLuaFiles = lib.mkMerge [
      {
        config = ./hyprland/lua/config.lua;
        theme =
          substitute {
            "@accent@" = helpers.hexToRgbHyprland config.lib.theme.accent;
            "@accent2@" = helpers.hexToRgbHyprland config.lib.theme.accent2;
            "@inactive@" = helpers.hexToRgbHyprland config.lib.theme.colors.surface0;
          }
          ./hyprland/lua/theme.lua;
        binds =
          substitute {
            "@layoutToggle@" = "${layoutToggle}";
            "@touchpadToggle@" = "${touchpadToggle}";
          }
          ./hyprland/lua/binds.lua;
        rules = rulesFile;
        autostart =
          substitute {
            "@cursorTheme@" = "catppuccin-${config.theme.variant}-${config.theme.accent}-cursors";
          }
          ./hyprland/lua/autostart.lua;
        plugins = ./hyprland/lua/plugins.lua;
      }
      (lib.mkIf hostOptions.desktop.hyprland.preferDedicatedLaptopGpu {
        gpu = ./hyprland/lua/gpu.lua;
      })
      (lib.mkIf hostOptions.hardware.corsair.enable {
        ckb = ./hyprland/lua/ckb.lua;
      })
    ];
  };

  # Must be synced with nixos module, due to home-manager bug that overrides.
  xdg.portal = {
    enable = lib.mkForce true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "gtk";
  };

  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
        allow_token_by_default=true
    }
  '';

  # Polkit agent for privilege escalation in text editors like vscode
  services.hyprpolkitagent.enable = true;
}
