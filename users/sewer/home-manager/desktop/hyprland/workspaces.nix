{...}: {
  wayland.windowManager.hyprland.settings = {
    # Workspace rules
    workspace = [
      "1, persistent:true"
      "2, persistent:true"
      "3, persistent:true"
      "4, persistent:true"
    ];

    # Window rules for specific applications
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
      "float, class:^(pavucontrol)$"
      "float, class:^(nm-connection-editor)$"

      # Size rules for floating windows
      "size 800 600, class:^(pavucontrol)$"
      "size 800 600, class:^(nm-connection-editor)$"
    ];

    # Autostart applications
    exec-once = [
      # System services
      "waybar"
      "dunst"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

      # Startup applications
      "code"
      "gitkraken"
      "slack"
      "telegram-desktop"
      "tidal"
      "thunderbird"

      # Background services
      "nm-applet --indicator"
      "blueman-applet"
    ];
  };
}
