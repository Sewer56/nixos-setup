{pkgs, ...}: {
  imports = [
    ./pipewire-volume-fix.nix
  ];
  # Audio packages
  environment.systemPackages = with pkgs; [
    pwvucontrol
    alsa-utils # For amixer command in systemd service
  ];

  # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler
  # for increased performance.
  security.rtkit.enable = true;
  hardware.alsa.enablePersistence = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;

    # Fix for Kanto ORA USB DAC not producing sound until 55% volume
    wireplumber.extraConfig."kanto-ora-config" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "~alsa_card.usb-Kanto_Audio_ORA_by_Kanto.*";
            }
          ];
          actions = {
            "update-props" = {
              # The fix is here.
              # "api.alsa.soft-mixer" = true;
            };
          };
        }
      ];
    };
  };
}
