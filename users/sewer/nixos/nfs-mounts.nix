{...}: {
  # User-level systemd mount configuration for NFS
  systemd.mounts = [{
    type = "nfs";
    what = "192.168.1.125:/mnt";
    where = "/home/sewer/NAS";
    options = "nfsvers=4,soft,intr,timeo=10,retrans=3";
  }];

  # User-level systemd automount configuration
  systemd.automounts = [{
    wantedBy = ["multi-user.target"];
    automountConfig = {
      TimeoutIdleSec = "300";  # Unmount after 5 minutes of inactivity
    };
    where = "/home/sewer/NAS";
  }];

  # Create the mount point directory
  systemd.tmpfiles.rules = [
    "d /home/sewer/NAS 0755 sewer users -"
  ];
}