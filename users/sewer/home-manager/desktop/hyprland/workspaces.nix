{
  lib,
  hostOptions,
  ...
}: {
  wayland.windowManager.hyprland.settings = lib.mkMerge [
    # ====== COMMON SETTINGS (Both ultrawide and standard modes) ======
    {
      # Autostart applications (apply regardless of ultrawide mode)
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
        "tidal-hifi"
        "proton-mail"
        "vivaldi"

        # Kill that wifi applet which I can't disable for the life of me.
        "sleep 5 && pkill -f 'iwgtk -i'"
      ];
    }

    # ====== ULTRAWIDE MODE SETTINGS ======
    (lib.mkIf hostOptions.desktop.hyprland.ultraWideMode {
      # Override general layout for ultrawide mode
      general.layout = lib.mkForce "workspacelayout";

      # Plugin configuration for wslayout
      plugin.wslayout = {
        default_layout = "master";
      };

      # Workspace-specific layout configurations
      # Ultrawide workspaces (1-4): Layout-optimized for ultrawide display
      # High workspaces (7-10): Uncommonly checked applications
      workspace = [
        # Ultrawide-specific workspaces with monitor assignment and layouts
        "0, layoutopt:wslayout-layout:master, default:true"
        "1, layoutopt:wslayout-layout:master"
        "2, layoutopt:wslayout-layout:master"
        "3, layoutopt:wslayout-layout:master"
        "4, layoutopt:wslayout-layout:dwindle"
      ];

      # Application workspace assignments optimized for ultrawide layout
      windowrulev2 = [
        # Workspace 1: Code/Browsers (master layout optimized for ultrawide)
        "workspace 1 silent, class:^(chromium-browser)$"
        "workspace 1 silent, class:^(vivaldi-stable)$"
        "workspace 1 silent, class:^(code)$"
        "workspace 1 silent, class:^(Code)$"
        "workspace 1 silent, class:^(vesktop)$"

        # Workspace 2: Secondary development tools (master layout)
        "workspace 2 silent, class:^(GitKraken)$"

        # Workspace 3: Communications (master layout)
        "workspace 3 silent, class:^(Slack)$"
        "workspace 3 silent, class:^(telegram-desktop)$"
        "workspace 3 silent, class:^(TelegramDesktop)$"

        # Workspace 4: Miscellaneous apps (dwindle layout)
        "workspace 4 silent, class:^(tidal-hifi)$"
        "workspace 4 silent, class:^(Proton Mail)$"

        # Floating window rules
        "float, title:^(Picture-in-Picture)$"
        "float, class:^(pwvucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "size 800 600, class:^(pwvucontrol)$"
        "size 800 600, class:^(nm-connection-editor)$"
      ];
    })

    # ====== STANDARD MODE SETTINGS ======
    (lib.mkIf (!hostOptions.desktop.hyprland.ultraWideMode) {
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

      # Application workspace assignments (standard mode)
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
        "workspace 8, class:^(tidal-hifi)$"

        # Workspace 9: Git
        "workspace 9, class:^(GitKraken)$"

        # Workspace 10: Email (bound to '0')
        "workspace 10, class:^(Proton Mail)$"

        # Floating window rules
        "float, title:^(Picture-in-Picture)$"
        "float, class:^(pwvucontrol)$"
        "float, class:^(nm-connection-editor)$"

        # Size rules for floating windows
        "size 800 600, class:^(pwvucontrol)$"
        "size 800 600, class:^(nm-connection-editor)$"
      ];
    })
  ];
}
