{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    file-roller
    brightnessctl
    libsecret # Provides secret-tool for testing keyring
    _010editor
    zip
    unzip
    qpwgraph
    ffmpeg
    bubblewrap

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Development tools
    telegram-desktop
    slack
    imhex
    ghidra
    postman

    # Media/torrents
    qbittorrent
    tauon

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
    proton-vpn

    # Desktop environment
    waybar
    hyprsunset

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
