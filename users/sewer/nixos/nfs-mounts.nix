{
  config,
  lib,
  ...
}: {
  # User-level systemd mount configuration for NFS
  systemd.mounts = lib.mkIf config.hostOptions.nas.enable [
    {
      type = "nfs";
      what = "DietPi.local:/mnt";
      where = "/home/sewer/NAS";
      options = "nfsvers=4,soft,intr,timeo=10,retrans=3,noauto";
      mountConfig = {
        TimeoutSec = "2";
        ForceUnmount = "yes";
      };
    }
  ];

  # User-level systemd automount configuration
  systemd.automounts = lib.mkIf config.hostOptions.nas.enable [
    {
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "0"; # Disable automatic unmounting
      };
      where = "/home/sewer/NAS";
    }
  ];

  # Create the mount point directory
  systemd.tmpfiles.rules = lib.mkIf config.hostOptions.nas.enable [
    "d /home/sewer/NAS 0755 sewer users -"
  ];
}
