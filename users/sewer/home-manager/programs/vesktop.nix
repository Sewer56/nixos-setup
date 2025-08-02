{...}: {
  programs.vesktop = {
    enable = true;

    # Optional: Specify a custom package if needed
    # package = pkgs.vesktop;

    # Vesktop settings (written to $XDG_CONFIG_HOME/vesktop/settings.json)
    settings = {
      # Minimize to tray when closing the window
      minimizeToTray = false;

      # Start minimized to tray
      startMinimized = false;

      # Enable hardware acceleration
      hardwareAcceleration = true;

      # Auto-update behavior
      autoUpdate = false;

      # Spellcheck settings
      spellcheck = true;

      # Notification settings
      notifications = {
        enable = true;
        flashWindow = true;
        showUnreadBadge = true;
      };
    };

    # Vencord settings (written to $XDG_CONFIG_HOME/vesktop/settings/settings.json)
    vencord = {
      settings = {
        # Basic Vencord settings
        useQuickCss = true;
        themeLinks = [];
        autoUpdate = true;
        autoUpdateNotification = true;
        eagerPatches = false;
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;

        # Plugin configurations from backup
        plugins = {
          # API plugins (auto-enabled)
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          DynamicImageModalAPI.enabled = true;
          MemberListDecoratorsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          MessagePopoverAPI.enabled = true;
          MessageUpdaterAPI.enabled = true;
          ServerListAPI.enabled = false;
          UserSettingsAPI.enabled = true;

          # User plugins (from backup - only enabled ones)
          AlwaysTrust.enabled = true;
          CopyFileContents.enabled = true;
          CrashHandler.enabled = true;
          Experiments.enabled = true;
          ForceOwnerCrown.enabled = true;
          FriendsSince.enabled = true;
          GifPaste.enabled = true;
          ImplicitRelationships.enabled = true;
          KeepCurrentChannel.enabled = true;
          MemberCount.enabled = true;
          MessageLatency.enabled = true;
          MessageLogger.enabled = true;
          PermissionFreeWill.enabled = true;
          PermissionsViewer.enabled = true;
          RelationshipNotifier.enabled = true;
          ReverseImageSearch.enabled = true;
          Summaries.enabled = true;
          SendTimestamps.enabled = true;
          ServerInfo.enabled = true;
          ShowConnections.enabled = true;
          ShowHiddenChannels.enabled = true;
          ShowHiddenThings.enabled = true;
          SortFriendRequests.enabled = true;
          Translate.enabled = true;
          TypingIndicator.enabled = true;
          TypingTweaks.enabled = true;
          Unindent.enabled = true;
          UserVoiceShow.enabled = true;
          USRBG.enabled = true;
          ValidUser.enabled = true;
          ViewRaw.enabled = true;
          VoiceDownload.enabled = true;
          VoiceMessages.enabled = true;
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;

          # Core plugins with specific settings
          BadgeAPI.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          DisableDeepLinks.enabled = true;
          SupportHelper.enabled = true;
          WebContextMenus.enabled = true;
        };

        # Notification settings from backup
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };

        # Cloud settings from backup
        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1754110885245;
        };
      };
    };
  };
}
