{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    nemo

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Desktop environment utilities
    hyprlock
    hypridle
    cliphist
    wl-clipboard
    grim
    slurp
    swappy

    # System tray utilities
    networkmanagerapplet

    # Development tools
    telegram-desktop
    slack

    # General Tools
    qalculate-gtk
  ];
}
