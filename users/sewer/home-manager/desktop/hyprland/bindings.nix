{pkgs, ...}: let
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
        hyprctl keyword "device[$TOUCHPAD]:enabled" true
        rm "$STATE_FILE"
        echo "Touchpad enabled"
    else
        # Touchpad is currently enabled, disable it
        hyprctl keyword "device[$TOUCHPAD]:enabled" false
        touch "$STATE_FILE"
        echo "Touchpad disabled"
    fi
  '';
in {
  home.packages = with pkgs; [
    playerctl # Music controls.
    killall
  ];

  wayland.windowManager.hyprland.settings = {
    # Set main modifier
    "$mod" = "SUPER";

    # Key bindings
    bind = [
      # Applications
      "$mod, Return, exec, alacritty"
      # Rofi bindings moved to programs/rofi/bindings.nix
      # Toggle bar. NixOS wrapping shenanigans
      "$mod, B, exec, killall waybar || killall .waybar-wrapped || waybar"
      # Lock screen binding moved to programs/idle-lock.nix

      # Window management
      "$mod, Q, killactive,"
      "$mod, M, exit,"
      "$mod, F, fullscreen,"
      "$mod, Space, togglefloating,"
      "$mod, P, pseudo," # dwindle
      "$mod, J, togglesplit," # dwindle

      # Focus movement
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # Layout management
      "$mod, W, layoutmsg, swapwithmaster" # Swap with previous window
      "$mod, E, layoutmsg, swapnext" # Swap with next window
      "$mod, O, layoutmsg, addmaster" # Add master window

      # Application pass-through bindings
      "ALT, 3, pass, ^(com\.obsproject\.Studio)$"
      "ALT, 4, pass, ^(com\.obsproject\.Studio)$"
      "$mod, C, pass, ^(qemu)$"

      # Window movement
      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"

      # Workspace switching
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Move window to workspace
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Scroll through workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Screenshot bindings moved to programs/screenshot.nix
      # Print = area to clipboard, Shift+Print = full to clipboard
      # Ctrl+Print = area to file, Ctrl+Shift+Print = full to file

      # Window switcher (Alt+Tab)
      # ALT+Tab binding moved to programs/rofi/bindings.nix

      # Clipboard manager binding moved to programs/clipboard.nix
      # Super+V = open clipboard history
    ];

    # Repeat key bindings
    binde = [
      # Resize windows
      "$mod CTRL, right, resizeactive, 50 0"
      "$mod CTRL, left, resizeactive, -50 0"
      "$mod CTRL, up, resizeactive, 0 -50"
      "$mod CTRL, down, resizeactive, 0 50"
    ];

    # Mouse bindings
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # Media keys
    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      # Mouse button volume controls
      ", mouse:281, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", mouse:282, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      # Brightness controls
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];

    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      # XF86TouchpadToggle . Broken on hyprland.
      ", code:269025193, exec, ${touchpadToggle}"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
