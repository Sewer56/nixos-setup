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
    # Wrapped clangd: resolves nix stdlib include paths out of the box.
    # (Repo-level --query-driver flag in project settings stays as safety net;
    # the wrapper detects it and skips its own injection, so they coexist.)
    clang-tools

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
    parsec-bin
    r2modman

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
    pnpm
    (jetbrains.rider.override {forceWayland = true;})

    # Profiling tools
    hotspot
    heaptrack
    rustc-demangle

    # Worktree manager
    wt

    # File transfer
    filezilla
  ];
}
