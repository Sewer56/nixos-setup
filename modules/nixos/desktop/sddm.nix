{...}: {
  # Login Screen / SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };

  # Machine-specific SDDM autologin
  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "hyprland-uwsm.desktop";
      User = "sewer";
    };
  };
}
