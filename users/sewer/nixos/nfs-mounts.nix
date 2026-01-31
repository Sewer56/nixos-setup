{
  config,
  lib,
  ...
}: let
  nasMode = config.hostOptions.nas.mode;
  nasTarget =
    if nasMode == "local"
    then "192.168.1.3:/mnt"
    else "nixos-homelab:/mnt";
in {
  # User-level systemd mount configuration for NFS
  systemd.mounts = lib.mkIf (nasMode != "disabled") [
    {
      type = "nfs";
      what = nasTarget;
      where = "/mnt/NAS";
      options = "nfsvers=4,soft,intr,timeo=10,retrans=3,noauto";
      mountConfig = {
        TimeoutSec = "2";
        ForceUnmount = "yes";
      };
    }
  ];

  # User-level systemd automount configuration
  systemd.automounts = lib.mkIf (nasMode != "disabled") [
    {
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "0"; # Disable automatic unmounting
      };
      where = "/mnt/NAS";
    }
  ];

  # Create the mount point directory
  systemd.tmpfiles.rules = lib.mkIf (nasMode != "disabled") [
    "d /mnt/NAS 0755 sewer users -"
  ];
}
