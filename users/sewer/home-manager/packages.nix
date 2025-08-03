{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    nemo
    file-roller
    brightnessctl

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Development tools
    telegram-desktop
    slack

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
  ];
}
