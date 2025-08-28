{...}: {
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable NetworkManager with iwd backend
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Enable wireless networking via iwd
  # Because wpa_supplicant is broken with Sewer's Access Point in 6GHz mode.
  networking.wireless.iwd.enable = true;
}
