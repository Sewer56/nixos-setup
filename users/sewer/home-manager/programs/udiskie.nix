{...}: {
  # Udiskie - GUI automounter for removable drives
  services.udiskie = {
    enable = true;
    automount = true; # Automatically mount new devices
    notify = true; # Show desktop notifications
    tray = "auto"; # Show tray icon when devices are available
  };
}
