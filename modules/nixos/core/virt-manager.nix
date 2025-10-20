# Virtual Machine Manager
{...}: {
  programs.virt-manager.enable = true;

  # Enable libvirtd daemon
  virtualisation.libvirtd.enable = true;

  # Enable SPICE USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  # Add user to libvirtd group (this should be configured in user settings)
  users.groups.libvirtd.members = ["sewer"];
  users.users.sewer.extraGroups = ["libvirtd"];
}
