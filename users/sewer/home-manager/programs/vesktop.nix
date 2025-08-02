{...}: {
  programs.vesktop = {
    enable = true;

    # Optional: Specify a custom package if needed
    # package = pkgs.vesktop;

    # Vesktop settings (written to $XDG_CONFIG_HOME/vesktop/settings.json)
    settings = {
      # Minimize to tray when closing the window
      minimizeToTray = true;

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
        # Enable/disable various Vencord features
        useQuickCss = true;
        themeLinks = [];
        enabledThemes = [];
      };

      # Optional: Add custom themes
      # themes = {
      #   "custom-theme" = builtins.readFile ./themes/custom-theme.css;
      # };
    };
  };
}
