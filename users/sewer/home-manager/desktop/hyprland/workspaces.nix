{...}: {
  wayland.windowManager.hyprland.settings = {
    # Workspace rules
    # Low workspaces (1-5): Common applications
    # High workspaces (8-0): Uncommonly checked applications
    workspace = [
      "1, persistent:true, default:true"
      "2, persistent:true"
      "3, persistent:true"
      "4, persistent:true"
      "7, persistent:true"
      "8, persistent:true"
      "9, persistent:true"
      "10, persistent:true"
    ];

    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    windowrulev2 = [
      # Common applications (low workspaces)
      # Workspace 1: Browsers
      "workspace 1, class:^(chromium-browser)$"
      "workspace 1, class:^(firefox)$"
      "workspace 1, class:^(vivaldi-stable)$"

      # Workspace 2: Code editors
      "workspace 2, class:^(Code)$"
      "workspace 2, class:^(code)$"
      "workspace 2, class:^(code-url-handler)$"

      # Workspace 3: Discord
      "workspace 3, class:^(discord)$"
      "workspace 3, class:^(vesktop)$"

      # Workspace 4: Slack
      "workspace 4, class:^(Slack)$"

      # Workspace 5: Communication
      "workspace 5, class:^(telegram-desktop)$"
      "workspace 5, class:^(TelegramDesktop)$"

      # Uncommonly checked applications (high workspaces)
      # Workspace 8: Music
      "workspace 8, class:^(Tidal)$"

      # Workspace 9: Git
      "workspace 9, class:^(GitKraken)$"

      # Workspace 10: Email (bound to '0')
      "workspace 10, class:^(thunderbird)$"

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
      "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

      # Startup applications
      "code"
      "vesktop"
      "gitkraken"
      "slack"
      "telegram-desktop"
      "tidal"
      "thunderbird"
      "vivaldi"

      # Kill that wifi applet which I can't disable for the life of me.
      "sleep 5 && pkill -f 'iwgtk -i'"
    ];
  };
}
