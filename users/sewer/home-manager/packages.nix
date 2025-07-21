{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    nemo

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Development tools
    telegram-desktop
    slack

    # General Tools
    qalculate-gtk

    # Desktop environment
    waybar

    # Fonts
    inter
  ];
}
