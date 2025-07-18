{...}: {
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking via NetworkManager
  # (Yes, it's not fully declarative, but I haven't yet
  #  figured how to store passwords here, nor do I want to)
  networking.networkmanager.enable = true;
}
