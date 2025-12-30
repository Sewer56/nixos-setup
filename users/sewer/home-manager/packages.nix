{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    file-roller
    brightnessctl
    _010editor
    zip
    unzip
    qpwgraph
    ffmpeg

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Development tools
    telegram-desktop
    slack
    imhex
    ghidra

    # Media/torrents
    qbittorrent

    # Wine
    wineWow64Packages.stagingFull
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
    protonvpn-gui

    # Desktop environment
    waybar

    # Fonts
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Development Environment
    devenv
    spec-kit
    (jetbrains.rider.override {forceWayland = true;})

    # Profiling tools
    hotspot
    heaptrack
    rustc-demangle

    # File transfer
    filezilla
  ];
}
