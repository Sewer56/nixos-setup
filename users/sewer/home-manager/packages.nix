{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    file-roller
    brightnessctl

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Development tools
    telegram-desktop
    slack

    # Media/torrents
    qbittorrent

    # Wine
    wine
    winetricks

    # Gaming/Emulators
    dolphin-emu
    pcsx2

    # General Tools
    qalculate-gtk
    qdirstat
    iwgtk
    feh
    libjxl

    # Desktop environment
    waybar

    # Fonts
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Development Environment
    devenv
    (jetbrains.rider.override {forceWayland = true;})
  ];
}
