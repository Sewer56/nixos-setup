{pkgs, ...}: {
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
      "$mod, D, exec, rofi -show drun"
      "$mod, R, exec, rofi -show run"
      # Toggle bar. NixOS wrapping shenanigans
      "$mod, B, exec, killall waybar || killall .waybar-wrapped || waybar"
      "$mod, Escape, exec, hyprlock"

      # Window management
      "$mod, Q, killactive,"
      "$mod, M, exit,"
      "$mod, F, fullscreen,"
      "$mod, Space, togglefloating,"
      "$mod, P, pseudo," # dwindle
      "$mod, T, togglesplit," # dwindle

      # Focus movement
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # Window movement
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, L, movewindow, r"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, J, movewindow, d"
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

      # Special workspace (scratchpad)
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Screenshot bindings
      ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      "SHIFT, Print, exec, grim - | wl-copy"
      "CTRL, Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
      "CTRL SHIFT, Print, exec, grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

      # Window switcher (Alt+Tab)
      "ALT, Tab, exec, rofi -show window"

      # Clipboard manager
      "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
    ];

    # Repeat key bindings
    binde = [
      # Resize windows
      "$mod CTRL, H, resizeactive, -10 0"
      "$mod CTRL, L, resizeactive, 10 0"
      "$mod CTRL, K, resizeactive, 0 -10"
      "$mod CTRL, J, resizeactive, 0 10"
      "$mod CTRL, left, resizeactive, -10 0"
      "$mod CTRL, right, resizeactive, 10 0"
      "$mod CTRL, up, resizeactive, 0 -10"
      "$mod CTRL, down, resizeactive, 0 10"
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
    ];

    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
