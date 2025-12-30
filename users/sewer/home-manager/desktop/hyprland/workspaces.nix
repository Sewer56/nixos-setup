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
        "slack --ozone-platform=wayland"
        "telegram-desktop"
        "spotify"
        "proton-mail"
        "vivaldi"
        "obsidian"
        "stretchly"
      ];
    }

    # ====== ULTRAWIDE MODE SETTINGS ======
    (lib.mkIf (hostOptions.desktop.hyprland.displayMode == "ultrawide") {
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
        "2, layoutopt:wslayout-layout:dwindle"
        "3, layoutopt:wslayout-layout:master"
        "4, layoutopt:wslayout-layout:dwindle"
      ];

      # Application workspace assignments optimized for ultrawide layout
      windowrule = [
        # Workspace 1: Code/Browsers (master layout optimized for ultrawide)
        "workspace 1 silent, match:class ^(chromium-browser)$"
        "workspace 1 silent, match:class ^(vivaldi-stable)$"
        "workspace 1 silent, match:class ^(code)$"
        "workspace 1 silent, match:class ^(Code)$"
        "workspace 1 silent, match:class ^(vesktop)$"

        # Workspace 2: Secondary development tools (master layout)
        "workspace 2 silent, match:class ^(GitKraken)$"
        "workspace 2 silent, match:class ^(obsidian)$"

        # Workspace 3: Communications (master layout)
        "workspace 3 silent, match:class ^(Slack)$"
        "workspace 3 silent, match:class ^(telegram-desktop)$"
        "workspace 3 silent, match:class ^(TelegramDesktop)$"

        # Workspace 4: Miscellaneous apps (dwindle layout)
        "workspace 4 silent, match:class ^(spotify)$"
        "workspace 4 silent, match:class ^(Proton Mail)$"

        # Floating window rules
        "float 1, match:title ^(Picture-in-Picture)$"
        "float 1, match:class ^(pwvucontrol)$"
        "float 1, match:class ^(nm-connection-editor)$"
        "size 800 600, match:class ^(pwvucontrol)$"
        "size 800 600, match:class ^(nm-connection-editor)$"
      ];
    })

    # ====== THREE SCREEN OFFICE SETUP ======
    (lib.mkIf (hostOptions.desktop.hyprland.displayMode == "threeScreens") {
      # Workspace rules with monitor assignments for three-screen setup
      workspace = [
        "1, monitor:DP-4, persistent:true, default:true" # Vivaldi - Left screen
        "2, monitor:DP-3, persistent:true" # Code - Middle screen
        "3, monitor:eDP-1, persistent:true" # Slack + Discord - Right screen (integrated)
        "4, monitor:eDP-1, persistent:true" # Other apps - Right screen
        "7, monitor:eDP-1, persistent:true" # Other apps - Right screen
        "8, monitor:eDP-1, persistent:true" # Other apps - Right screen
        "9, monitor:eDP-1, persistent:true" # Other apps - Right screen
        "10, monitor:eDP-1, persistent:true" # Other apps - Right screen
      ];

      # Application workspace assignments for three-screen setup
      windowrule = [
        # Workspace 1: Vivaldi - Left screen (DP-4)
        "workspace 1, match:class ^(vivaldi-stable)$"
        "workspace 1, match:class ^(chromium-browser)$"
        "workspace 1, match:class ^(firefox)$"

        # Workspace 2: Code - Middle screen (DP-3)
        "workspace 2, match:class ^(Code)$"
        "workspace 2, match:class ^(code)$"
        "workspace 2, match:class ^(code-url-handler)$"

        # Workspace 3: Slack AND Discord - Right screen (eDP-1)
        "workspace 3, match:class ^(Slack)$"
        "workspace 3, match:class ^(discord)$"
        "workspace 3, match:class ^(vesktop)$"

        # Other workspaces on right screen (eDP-1)
        "workspace 4, match:class ^(telegram-desktop)$"
        "workspace 4, match:class ^(TelegramDesktop)$"
        "workspace 7, match:class ^(obsidian)$"
        "workspace 8, match:class ^(spotify)$"
        "workspace 9, match:class ^(GitKraken)$"
        "workspace 10, match:class ^(Proton Mail)$"

        # Floating window rules
        "float 1, match:title ^(Picture-in-Picture)$"
        "float 1, match:class ^(pwvucontrol)$"
        "float 1, match:class ^(nm-connection-editor)$"
        "size 800 600, match:class ^(pwvucontrol)$"
        "size 800 600, match:class ^(nm-connection-editor)$"
      ];
    })

    # ====== STANDARD MODE SETTINGS ======
    (lib.mkIf (hostOptions.desktop.hyprland.displayMode == "single") {
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
      windowrule = [
        # Common applications (low workspaces)
        # Workspace 1: Browsers
        "workspace 1, match:class ^(chromium-browser)$"
        "workspace 1, match:class ^(firefox)$"
        "workspace 1, match:class ^(vivaldi-stable)$"

        # Workspace 2: Code editors
        "workspace 2, match:class ^(Code)$"
        "workspace 2, match:class ^(code)$"
        "workspace 2, match:class ^(code-url-handler)$"

        # Workspace 3: Discord
        "workspace 3, match:class ^(discord)$"
        "workspace 3, match:class ^(vesktop)$"

        # Workspace 4: Slack
        "workspace 4, match:class ^(Slack)$"

        # Workspace 5: Communication
        "workspace 5, match:class ^(telegram-desktop)$"
        "workspace 5, match:class ^(TelegramDesktop)$"

        # Uncommonly checked applications (high workspaces)
        # Workspace 7: Notes
        "workspace 7, match:class ^(obsidian)$"

        # Workspace 8: Music
        "workspace 8, match:class ^(spotify)$"

        # Workspace 9: Git
        "workspace 9, match:class ^(GitKraken)$"

        # Workspace 10: Email (bound to '0')
        "workspace 10, match:class ^(Proton Mail)$"

        # Floating window rules
        "float 1, match:title ^(Picture-in-Picture)$"
        "float 1, match:class ^(pwvucontrol)$"
        "float 1, match:class ^(nm-connection-editor)$"

        # Size rules for floating windows
        "size 800 600, match:class ^(pwvucontrol)$"
        "size 800 600, match:class ^(nm-connection-editor)$"
      ];
    })
  ];
}
