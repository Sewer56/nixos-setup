{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    nemo
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

    # Desktop environment
    waybar

    # Fonts
    inter
  ];
}
