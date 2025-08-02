{...}: {
  # Enable Steam gaming platform
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    # Fractional scaling support
    gamescopeSession.enable = true;
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  # Enable AppImage support for games
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
