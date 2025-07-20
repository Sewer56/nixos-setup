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
    qalculate-gtk

    # System tray utilities
    networkmanagerapplet
    blueman

    # Audio control
    pavucontrol
    playerctl

    # Development tools
    telegram-desktop
    slack
  ];
}
