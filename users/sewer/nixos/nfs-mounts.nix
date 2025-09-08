{...}: {
  # User-level systemd mount configuration for NFS
  systemd.mounts = [
    {
      type = "nfs";
      what = "192.168.1.125:/mnt";
      where = "/home/sewer/NAS";
      options = "nfsvers=4,soft,intr,timeo=10,retrans=3,noauto";
      mountConfig = {
        TimeoutSec = "2";
        ForceUnmount = "yes";
      };
    }
  ];

  # User-level systemd automount configuration
  systemd.automounts = [
    {
      automountConfig = {
        TimeoutIdleSec = "0"; # Disable automatic unmounting
      };
      where = "/home/sewer/NAS";
    }
  ];

  # Create the mount point directory
  systemd.tmpfiles.rules = [
    "d /home/sewer/NAS 0755 sewer users -"
  ];
}
