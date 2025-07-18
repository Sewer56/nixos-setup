{ pkgs, ... }: {
  # System-wide packages available to all users
  environment.systemPackages = with pkgs; [
    # System utilities
    fastfetch
    pavucontrol
    btop
    nvitop
    nemo
    
    # Browser (system-wide for all users)
    vivaldi
    vivaldi-ffmpeg-codecs
  ];
}