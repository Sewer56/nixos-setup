{...}: {
  hardware.i2c.enable = true;

  boot.kernelModules = ["i2c-dev"];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
}
