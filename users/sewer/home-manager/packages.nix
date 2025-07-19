{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    fastfetch
    btop
    nemo

    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs

    # Terminal emulators
    alacritty

    # Desktop environment utilities
    waybar
    rofi-wayland
    dunst
    hyprlock
    hypridle
    cliphist
    wl-clipboard
    grim
    slurp
    swappy

    # System tray utilities
    networkmanagerapplet
    blueman

    # Audio control
    pavucontrol
    playerctl

    # Development tools
    telegram-desktop
    slack
    thunderbird

    # Polkit agent
    polkit_gnome
  ];
}
