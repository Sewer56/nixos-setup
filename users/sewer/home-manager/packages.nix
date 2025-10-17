{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    file-roller
    brightnessctl
    kdiskmark
    _010editor

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Development tools
    telegram-desktop
    slack
    imhex

    # Media/torrents
    qbittorrent

    # Wine
    wineWow64Packages.waylandFull
    winetricks

    # Gaming/Emulators
    dolphin-emu
    pcsx2
    xenia-canary

    # General Tools
    qalculate-gtk
    qdirstat
    feh
    libjxl

    # VPN
    protonvpn-cli
    protonvpn-gui

    # Desktop environment
    waybar

    # Fonts
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Development Environment
    devenv
    (jetbrains.rider.override {forceWayland = true;})
    
    # Profiling tools
    hotspot
  ];
}
