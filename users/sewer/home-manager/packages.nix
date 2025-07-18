{ pkgs, ... }: {
  # User-specific packages
  home.packages = with pkgs; [
    # System utilities
    fastfetch
    btop
    nemo
    
    # Browser (user-specific)
    vivaldi
    vivaldi-ffmpeg-codecs
  ];
}