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
    feh
    libjxl

    # Desktop environment
    waybar

    # Fonts
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Python environment for wallpaper color analysis
    (python3.withPackages (ps:
      with ps; [
        pillow
        scikit-image
        colormath
        scikit-learn
        numpy
      ]))
  ];
}
