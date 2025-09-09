{pkgs, ...}: {
  # Enable Steam gaming platform
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    # Enable protontricks for managing Proton prefixes
    protontricks.enable = true;
    # Fractional scaling support
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      gamescope
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib # Provides libstdc++.so.6
      libkrb5
      keyutils
    ];
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
