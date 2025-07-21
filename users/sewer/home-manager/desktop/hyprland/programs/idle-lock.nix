{pkgs, ...}: {
  # Idle management and screen locking for Hyprland
  home.packages = with pkgs; [
    hyprlock  # Screen locker for Hyprland
    hypridle  # Idle daemon for Hyprland
  ];

  # Configure hypridle for automatic locking
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 300;  # 5 minutes
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      # Lock screen manually
      "$mod, Escape, exec, hyprlock"
    ];
  };
}