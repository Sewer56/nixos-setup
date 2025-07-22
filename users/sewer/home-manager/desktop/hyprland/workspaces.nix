{...}: {
  wayland.windowManager.hyprland.settings = {
    # Workspace rules
    workspace = [
      "1, persistent:true"
      "2, persistent:true"
      "3, persistent:true"
      "4, persistent:true"
    ];

    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    windowrulev2 = [
      # Workspace 1: Code editors and browsers
      "workspace 1, class:^(Code)$"
      "workspace 1, class:^(code-url-handler)$"
      "workspace 1, class:^(chromium-browser)$"

      # Workspace 2: Git and development tools
      "workspace 2, class:^(GitKraken)$"

      # Workspace 3: Communication
      "workspace 3, class:^(Slack)$"
      "workspace 3, class:^(telegram-desktop)$"
      "workspace 3, class:^(TelegramDesktop)$"

      # Workspace 4: Misc applications
      "workspace 4, class:^(Tidal)$"
      "workspace 4, class:^(thunderbird)$"

      # Floating windows
      "float, title:^(Picture-in-Picture)$"
      "float, class:^(pwvucontrol)$"
      "float, class:^(nm-connection-editor)$"

      # Size rules for floating windows
      "size 800 600, class:^(pwvucontrol)$"
      "size 800 600, class:^(nm-connection-editor)$"
    ];

    # Autostart applications
    exec-once = [
      # System services
      "waybar"
      "dunst"
      "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

      # Startup applications
      "code"
      "gitkraken"
      "slack"
      "telegram-desktop"
      "tidal"
      "thunderbird"

      # iwgtk auto enables indicator via systemd service.
      # I tried to kill it with overrideattrs, but no ball.
      "pkill -f 'iwgtk -i'"
    ];
  };
}
