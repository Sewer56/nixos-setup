{pkgs, ...}: {
  # Enable SANE scanner support
  hardware.sane = {
    enable = true;

    # Extra backends for various scanner brands
    extraBackends = with pkgs; [
      sane-airscan # Driverless Apple AirScan and Microsoft WSD
      hplipWithPlugin # HP scanners
      epkowa # Epson scanners (epkowa backend)
      utsushi # Epson scanners (newer models)
    ];

    # Disable default escl backend to avoid duplicate scanner detection with sane-airscan
    disabledDefaultBackends = ["escl"];
  };

  # Required for scanner detection
  services.udev.packages = with pkgs; [
    sane-airscan
    utsushi
  ];

  # Enable IPP-USB for USB-connected network scanners
  services.ipp-usb.enable = true;
}
