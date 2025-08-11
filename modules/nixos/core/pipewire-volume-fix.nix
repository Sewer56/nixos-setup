{pkgs, ...}: {
  # Override PipeWire package just for the service
  services.pipewire.package = pkgs.pipewire.overrideAttrs (oldAttrs: {
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        cp ${/etc/nixos/overlays/pipewire-volume-fix/kanto-ora-usb-dac.conf} $out/share/alsa-card-profile/mixer/profile-sets/kanto-ora-usb-dac.conf
        cp ${/etc/nixos/overlays/pipewire-volume-fix/90-pipewire-kanto-ora.rules} $out/lib/udev/rules.d/90-pipewire-kanto-ora.rules
      '';
  });
}
